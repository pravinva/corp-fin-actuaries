"""Bootstrap synthetic demo data for Corporate Finance Actuarial."""

from datetime import date, timedelta

from pyspark.sql import SparkSession

from src.config.runtime_config import CONFIG


def _fqdn(schema_name: str, table_name: str) -> str:
    return f"{CONFIG.catalog}.{schema_name}.{table_name}"


def _portfolio_codes() -> list[str]:
    return ["motor", "home", "ctp", "commercial"]


def create_policy_extract(spark: SparkSession, as_at_date: str) -> None:
    rows = []
    start_date = date.fromisoformat(as_at_date)
    for idx in range(1, 41):
        inception = start_date - timedelta(days=365 + idx)
        expiry = inception + timedelta(days=365)
        rows.append(
            (
                f"POL{idx:04d}",
                f"CUST{(idx % 15) + 1:03d}",
                _portfolio_codes()[idx % len(_portfolio_codes())],
                inception.isoformat(),
                expiry.isoformat(),
                as_at_date,
            )
        )

    schema = "policy_id string, customer_id string, portfolio_code string, inception_date date, expiry_date date, as_at_date date"
    df = spark.createDataFrame(rows, schema=schema)
    df.write.mode("overwrite").saveAsTable(_fqdn(CONFIG.landing_schema, "policy_extract"))


def create_claims_extract(spark: SparkSession, as_at_date: str, movement_multiplier: float = 1.0) -> None:
    rows = []
    as_at = date.fromisoformat(as_at_date)
    for idx in range(1, 61):
        loss_date = as_at - timedelta(days=(idx % 180) + 1)
        report_date = loss_date + timedelta(days=(idx % 7))
        claim_amount = round((800 + (idx * 35)) * movement_multiplier, 2)
        rows.append(
            (
                f"CLM{idx:05d}",
                f"POL{((idx % 40) + 1):04d}",
                _portfolio_codes()[idx % len(_portfolio_codes())],
                loss_date.isoformat(),
                report_date.isoformat(),
                claim_amount,
                as_at_date,
            )
        )

    schema = (
        "claim_id string, policy_id string, portfolio_code string, loss_date date, "
        "report_date date, claim_amount double, as_at_date date"
    )
    df = spark.createDataFrame(rows, schema=schema)
    df.write.mode("overwrite").saveAsTable(_fqdn(CONFIG.landing_schema, "claims_extract"))


def create_reinsurance_extract(spark: SparkSession, as_at_date: str, recovery_ratio: float = 0.2) -> None:
    rows = []
    for idx in range(1, 61):
        claim_amount = 800 + (idx * 35)
        recovery = round(claim_amount * recovery_ratio, 2)
        rows.append((f"TRT{idx:05d}", f"CLM{idx:05d}", recovery, as_at_date))

    schema = "treaty_id string, claim_id string, reinsurance_recovery_amount double, as_at_date date"
    df = spark.createDataFrame(rows, schema=schema)
    df.write.mode("overwrite").saveAsTable(_fqdn(CONFIG.landing_schema, "reinsurance_extract"))


def create_finance_extract(spark: SparkSession, as_at_date: str, movement_bias: float = 1.0) -> None:
    rows = []
    for idx, portfolio in enumerate(_portfolio_codes(), start=1):
        opening = 1_000_000 + (idx * 110_000)
        movement = round((50_000 + (idx * 7_500)) * movement_bias, 2)
        closing = opening + movement
        rows.append((f"JRNL{idx:04d}", portfolio, opening, closing, movement, as_at_date))

    schema = (
        "journal_id string, portfolio_code string, opening_liability double, "
        "closing_liability double, movement_amount double, as_at_date date"
    )
    df = spark.createDataFrame(rows, schema=schema)
    df.write.mode("overwrite").saveAsTable(_fqdn(CONFIG.landing_schema, "finance_extract"))


def bootstrap_demo_data(
    spark: SparkSession,
    as_at_date: str,
    movement_multiplier: float = 1.0,
    recovery_ratio: float = 0.2,
    movement_bias: float = 1.0,
) -> None:
    create_policy_extract(spark, as_at_date)
    create_claims_extract(spark, as_at_date, movement_multiplier=movement_multiplier)
    create_reinsurance_extract(spark, as_at_date, recovery_ratio=recovery_ratio)
    create_finance_extract(spark, as_at_date, movement_bias=movement_bias)
