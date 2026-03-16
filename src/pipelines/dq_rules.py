"""Data quality rule definitions for Corporate Finance Actuarial datasets."""

from pyspark.sql import DataFrame
from pyspark.sql import functions as F


def apply_claims_rules(df: DataFrame) -> DataFrame:
    """Attach row-level quality flags for claims data."""
    return (
        df.withColumn("dq_claim_amount_non_negative", F.col("claim_amount") >= F.lit(0))
        .withColumn("dq_report_after_loss", F.col("report_date") >= F.col("loss_date"))
        .withColumn("dq_claim_id_present", F.col("claim_id").isNotNull())
    )


def apply_policy_rules(df: DataFrame) -> DataFrame:
    """Attach row-level quality flags for policy data."""
    return (
        df.withColumn("dq_policy_id_present", F.col("policy_id").isNotNull())
        .withColumn("dq_inception_before_expiry", F.col("inception_date") <= F.col("expiry_date"))
    )


def split_valid_and_quarantine(df: DataFrame, rule_columns: list[str]) -> tuple[DataFrame, DataFrame]:
    """Split data by boolean rule results."""
    quality_expression = " AND ".join(rule_columns)
    valid_df = df.filter(F.expr(quality_expression))
    quarantine_df = df.filter(~F.expr(quality_expression))
    return valid_df, quarantine_df


def build_rule_summary(df: DataFrame, rule_columns: list[str], dataset_name: str) -> DataFrame:
    """Create a quality summary table for monitoring and controls."""
    aggregations = [F.count(F.lit(1)).alias("total_record_count")]
    for rule in rule_columns:
        pass_col = F.sum(F.when(F.col(rule), F.lit(1)).otherwise(F.lit(0))).alias(f"{rule}_pass_count")
        fail_col = F.sum(F.when(~F.col(rule), F.lit(1)).otherwise(F.lit(0))).alias(f"{rule}_fail_count")
        aggregations.extend([pass_col, fail_col])

    return (
        df.agg(*aggregations)
        .withColumn("dataset_name", F.lit(dataset_name))
        .withColumn("dq_run_timestamp", F.current_timestamp())
    )
