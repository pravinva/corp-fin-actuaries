"""Pipeline scaffold for Corporate Finance Actuarial data products."""

from pyspark.sql import DataFrame, SparkSession
from pyspark.sql import functions as F

from src.config.runtime_config import CONFIG
from src.pipelines.dq_rules import (
    apply_claims_rules,
    apply_policy_rules,
    build_rule_summary,
    split_valid_and_quarantine,
)


def _fqdn(schema_name: str, table_name: str) -> str:
    return f"{CONFIG.catalog}.{schema_name}.{table_name}"


def load_table(spark: SparkSession, table_name: str) -> DataFrame:
    return spark.table(table_name)


def save_table(df: DataFrame, schema_name: str, table_name: str, mode: str = "overwrite") -> None:
    writer = df.write.mode(mode)
    if mode == "overwrite":
        writer = writer.option("overwriteSchema", "true")
    writer.saveAsTable(_fqdn(schema_name, table_name))


def build_claims_silver(claims_raw: DataFrame, reinsurance_raw: DataFrame) -> DataFrame:
    claims_rules_df = apply_claims_rules(claims_raw).withColumn("load_timestamp", F.current_timestamp())
    rule_columns = [
        "dq_claim_amount_non_negative",
        "dq_report_after_loss",
        "dq_claim_id_present",
    ]
    valid_claims_df, quarantine_claims_df = split_valid_and_quarantine(claims_rules_df, rule_columns)
    save_table(quarantine_claims_df, CONFIG.quarantine_schema, "claims_dq_quarantine")
    summary_df = build_rule_summary(claims_rules_df, rule_columns, "claims")
    save_table(summary_df, CONFIG.gold_schema, "dq_claims_summary", mode="append")

    reinsurance_cols = ["claim_id", "reinsurance_recovery_amount"]
    return (
        valid_claims_df.join(
            reinsurance_raw.select(*reinsurance_cols),
            on="claim_id",
            how="left",
        )
        .withColumn("net_claim_amount", F.col("claim_amount") - F.coalesce(F.col("reinsurance_recovery_amount"), F.lit(0)))
    )


def build_policy_silver(policy_raw: DataFrame) -> DataFrame:
    policy_rules_df = apply_policy_rules(policy_raw).withColumn("load_timestamp", F.current_timestamp())
    rule_columns = ["dq_policy_id_present", "dq_inception_before_expiry"]
    valid_policy_df, quarantine_policy_df = split_valid_and_quarantine(policy_rules_df, rule_columns)
    save_table(quarantine_policy_df, CONFIG.quarantine_schema, "policy_dq_quarantine")
    summary_df = build_rule_summary(policy_rules_df, rule_columns, "policy")
    save_table(summary_df, CONFIG.gold_schema, "dq_policy_summary", mode="append")
    return valid_policy_df


def build_gold_views(claims_silver: DataFrame, policy_silver: DataFrame, finance_raw: DataFrame) -> None:
    movement_bridge = (
        finance_raw.groupBy("portfolio_code", "as_at_date")
        .agg(
            F.sum("opening_liability").alias("opening_liability"),
            F.sum("closing_liability").alias("closing_liability"),
            F.sum("movement_amount").alias("movement_amount"),
        )
        .withColumn("movement_ratio", F.col("movement_amount") / F.when(F.col("opening_liability") == 0, F.lit(1)).otherwise(F.col("opening_liability")))
        .withColumn("opening_liability", F.col("opening_liability").cast("decimal(18,1)"))
        .withColumn("closing_liability", F.col("closing_liability").cast("decimal(21,3)"))
        .withColumn("movement_amount", F.col("movement_amount").cast("decimal(20,2)"))
        .withColumn("movement_ratio", F.col("movement_ratio").cast("decimal(38,19)"))
    )
    save_table(movement_bridge, CONFIG.gold_schema, "valuation_movement_bridge")

    gross_net_view = (
        claims_silver.groupBy("portfolio_code", "as_at_date")
        .agg(
            F.sum("claim_amount").alias("gross_claim_amount"),
            F.sum("net_claim_amount").alias("net_claim_amount"),
        )
        .withColumn("reinsurance_impact", F.col("gross_claim_amount") - F.col("net_claim_amount"))
    )
    save_table(gross_net_view, CONFIG.gold_schema, "gross_to_net_liability_view")

    close_readiness = (
        policy_silver.groupBy("as_at_date")
        .agg(F.countDistinct("policy_id").alias("policy_record_count"))
        .join(
            claims_silver.groupBy("as_at_date").agg(F.countDistinct("claim_id").alias("claim_record_count")),
            on="as_at_date",
            how="outer",
        )
        .withColumn("close_readiness_flag", (F.col("policy_record_count") > 0) & (F.col("claim_record_count") > 0))
    )
    save_table(close_readiness, CONFIG.gold_schema, "close_readiness_indicators")

    # Persist run snapshots for simple time-travel demos in reporting views.
    snapshot_df = (
        movement_bridge.select(
            "portfolio_code",
            "as_at_date",
            "opening_liability",
            "closing_liability",
            "movement_amount",
            "movement_ratio",
        )
        .withColumn("snapshot_timestamp", F.current_timestamp())
    )
    save_table(snapshot_df, CONFIG.gold_schema, "valuation_movement_snapshots")


def run_pipeline(spark: SparkSession) -> None:
    claims_raw = load_table(spark, _fqdn(CONFIG.landing_schema, "claims_extract"))
    policy_raw = load_table(spark, _fqdn(CONFIG.landing_schema, "policy_extract"))
    reinsurance_raw = load_table(spark, _fqdn(CONFIG.landing_schema, "reinsurance_extract"))
    finance_raw = load_table(spark, _fqdn(CONFIG.landing_schema, "finance_extract"))

    claims_silver = build_claims_silver(claims_raw, reinsurance_raw)
    policy_silver = build_policy_silver(policy_raw)

    save_table(claims_silver, CONFIG.silver_schema, "claims_silver")
    save_table(policy_silver, CONFIG.silver_schema, "policy_silver")

    build_gold_views(claims_silver, policy_silver, finance_raw)


if __name__ == "__main__":
    spark_session = SparkSession.builder.getOrCreate()
    run_pipeline(spark_session)
