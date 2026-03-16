"""Build complete demo state for governance, quality, time travel, and Genie."""

import sys
from pathlib import Path

from pyspark.sql import SparkSession


def _bootstrap_sys_path() -> None:
    candidates = []
    if "__file__" in globals():
        candidates.append(Path(__file__).resolve().parents[1])
    candidates.extend(
        [
            Path.cwd(),
            Path("/Workspace/Users/pravin.varma@databricks.com/.bundle/corporate-finance-actuarial/dev/files"),
        ]
    )
    for candidate in candidates:
        src_path = candidate / "src"
        if src_path.exists():
            candidate_str = str(candidate)
            if candidate_str not in sys.path:
                sys.path.insert(0, candidate_str)
            break


_bootstrap_sys_path()

from src.pipelines.bootstrap_demo_data import bootstrap_demo_data
from src.pipelines.finance_actuarial_pipeline import run_pipeline


def main() -> None:
    spark = SparkSession.builder.appName("corp-fin-actuarial-demo-state").getOrCreate()

    # Run 1: baseline as-at snapshot.
    bootstrap_demo_data(
        spark=spark,
        as_at_date="2026-02-28",
        movement_multiplier=1.0,
        recovery_ratio=0.20,
        movement_bias=1.0,
    )
    run_pipeline(spark)

    # Run 2: changed assumptions to create additional Delta versions for time travel.
    bootstrap_demo_data(
        spark=spark,
        as_at_date="2026-03-31",
        movement_multiplier=1.06,
        recovery_ratio=0.18,
        movement_bias=1.08,
    )
    run_pipeline(spark)

    print("Demo state creation complete. Landing, conformed, reporting, quarantine and snapshot tables are populated.")


if __name__ == "__main__":
    main()
