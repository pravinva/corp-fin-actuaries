"""Runtime configuration for the Corporate Finance Actuarial pipeline."""

from dataclasses import dataclass


@dataclass(frozen=True)
class RuntimeConfig:
    catalog: str = "corp_fin_actuarial"
    bronze_schema: str = "raw_fin_actuarial"
    silver_schema: str = "conformed_fin_actuarial"
    gold_schema: str = "reporting_fin_actuarial"
    quarantine_schema: str = "quarantine_fin_actuarial"
    processing_date_column: str = "as_at_date"


CONFIG = RuntimeConfig()
