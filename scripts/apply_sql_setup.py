"""Execute SQL setup files in order using Spark SQL."""

from pathlib import Path

from pyspark.sql import SparkSession


SQL_FILES_IN_ORDER = [
    "src/sql/00_create_schemas.sql",
    "src/sql/05_seed_demo_data.sql",
    "src/sql/10_gold_views.sql",
    "src/sql/20_governance_setup.sql",
    "src/sql/21_governance_verification.sql",
    "src/sql/30_quality_monitoring_queries.sql",
    "src/sql/40_time_travel_demo.sql",
    "src/sql/50_genie_setup.sql",
    "src/sql/51_genie_benchmark_tables.sql",
    "src/sql/52_seed_genie_benchmarks.sql",
]


def _read_sql_text(repo_root: Path, relative_path: str) -> str:
    return (repo_root / relative_path).read_text(encoding="utf-8")


def _split_statements(sql_text: str) -> list[str]:
    statements = []
    current = []
    for line in sql_text.splitlines():
        stripped = line.strip()
        if stripped.startswith("--"):
            continue
        current.append(line)
        if ";" in line:
            statement = "\n".join(current).strip()
            if statement:
                statements.append(statement.rstrip(";"))
            current = []

    trailing = "\n".join(current).strip()
    if trailing:
        statements.append(trailing.rstrip(";"))
    return statements


def main() -> None:
    spark = SparkSession.builder.appName("corporate-finance-sql-setup").getOrCreate()
    candidates = []
    if "__file__" in globals():
        candidates.append(Path(__file__).resolve().parents[1])
    candidates.extend(
        [
            Path.cwd(),
            Path("/Workspace/Users/pravin.varma@databricks.com/.bundle/corporate-finance-actuarial/dev/files"),
        ]
    )
    repo_root = None
    for candidate in candidates:
        if (candidate / "src" / "sql").exists():
            repo_root = candidate
            break
    if repo_root is None:
        raise FileNotFoundError("Could not locate repository root with src/sql directory")

    for file_path in SQL_FILES_IN_ORDER:
        sql_text = _read_sql_text(repo_root, file_path)
        statements = _split_statements(sql_text)
        failures = 0
        for statement in statements:
            try:
                spark.sql(statement)
            except Exception as exc:  # noqa: BLE001
                failures += 1
                print(f"[WARN] Failed statement in {file_path}: {exc}")
        print(f"Applied {file_path} ({len(statements)} statements, failures={failures})")

    print("SQL setup complete.")


if __name__ == "__main__":
    main()
