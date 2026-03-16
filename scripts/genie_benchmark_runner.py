"""Materialize Genie benchmark catalog and expected result evidence."""

import json
import sys
from pathlib import Path

from pyspark.sql import Row, SparkSession
from pyspark.sql import functions as F


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

from src.config.runtime_config import CONFIG


def _fqdn(schema_name: str, table_name: str) -> str:
    return f"{CONFIG.catalog}.{schema_name}.{table_name}"


def _benchmarks_path() -> Path:
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
        path = candidate / "prompts" / "workstreams" / "genie_benchmarks.json"
        if path.exists():
            return path
    raise FileNotFoundError("Could not locate prompts/workstreams/genie_benchmarks.json")


def load_benchmarks() -> list[dict]:
    with _benchmarks_path().open("r", encoding="utf-8") as f:
        return json.load(f)


def write_benchmark_catalog(spark: SparkSession, benchmarks: list[dict]) -> None:
    rows = [
        Row(
            benchmark_id=b["benchmark_id"],
            benchmark_question=b["benchmark_question"],
            expected_sql=b["expected_sql"],
            benchmark_domain=b["benchmark_domain"],
            priority=b["priority"],
        )
        for b in benchmarks
    ]
    df = spark.createDataFrame(rows).withColumn("created_timestamp", F.current_timestamp())
    df.write.mode("overwrite").saveAsTable(_fqdn(CONFIG.gold_schema, "genie_benchmark_catalog"))


def materialize_expected_results(spark: SparkSession, benchmarks: list[dict]) -> None:
    result_rows = []
    for benchmark in benchmarks:
        result_df = spark.sql(benchmark["expected_sql"])
        json_rows = [row.asDict(recursive=True) for row in result_df.limit(100).collect()]
        result_rows.append(
            Row(
                benchmark_id=benchmark["benchmark_id"],
                result_json=json.dumps(json_rows, default=str),
                expected_result_row_count=result_df.count(),
            )
        )

    expected_df = spark.createDataFrame(result_rows).withColumn("generated_timestamp", F.current_timestamp())
    expected_df.write.mode("overwrite").saveAsTable(_fqdn(CONFIG.gold_schema, "genie_benchmark_expected_results"))


def main() -> None:
    spark = SparkSession.builder.appName("corp-fin-actuarial-genie-benchmarks").getOrCreate()
    benchmarks = load_benchmarks()
    write_benchmark_catalog(spark, benchmarks)
    materialize_expected_results(spark, benchmarks)
    print("Genie benchmark catalog and expected results generated.")


if __name__ == "__main__":
    main()
