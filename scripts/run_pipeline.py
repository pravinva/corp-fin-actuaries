"""Local entry point for running the finance actuarial pipeline."""

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

from src.pipelines.finance_actuarial_pipeline import run_pipeline


def main() -> None:
    spark = SparkSession.builder.appName("corp-fin-actuarial-pipeline").getOrCreate()
    run_pipeline(spark)


if __name__ == "__main__":
    main()
