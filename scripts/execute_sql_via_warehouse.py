"""Execute SQL files against Databricks SQL warehouse using DEFAULT profile."""

from __future__ import annotations

import json
import subprocess
from pathlib import Path


WAREHOUSE_ID = "30d6e63b35f828c5"
PROFILE = "DEFAULT"

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


def split_sql_statements(sql_text: str) -> list[str]:
    statements = []
    current: list[str] = []
    for line in sql_text.splitlines():
        stripped = line.strip()
        if stripped.startswith("--"):
            continue
        current.append(line)
        if ";" in line:
            stmt = "\n".join(current).strip().rstrip(";")
            if stmt:
                statements.append(stmt)
            current = []

    tail = "\n".join(current).strip().rstrip(";")
    if tail:
        statements.append(tail)
    return statements


def execute_statement(statement: str) -> dict:
    payload = {"warehouse_id": WAREHOUSE_ID, "statement": statement}
    cmd = [
        "databricks",
        "api",
        "post",
        "/api/2.0/sql/statements",
        "--profile",
        PROFILE,
        "--json",
        json.dumps(payload),
    ]
    proc = subprocess.run(cmd, capture_output=True, text=True, check=False)
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr or proc.stdout)
    return json.loads(proc.stdout)


def main() -> None:
    repo_root = Path(__file__).resolve().parents[1]
    total_failures = 0

    for relative_path in SQL_FILES_IN_ORDER:
        sql_text = (repo_root / relative_path).read_text(encoding="utf-8")
        statements = split_sql_statements(sql_text)
        failures = 0
        for statement in statements:
            try:
                response = execute_statement(statement)
                state = response.get("status", {}).get("state")
                if state != "SUCCEEDED":
                    failures += 1
                    error_msg = response.get("status", {}).get("error", {}).get("message", "unknown error")
                    print(f"[WARN] {relative_path} status={state} error={error_msg}")
            except Exception as exc:  # noqa: BLE001
                failures += 1
                print(f"[WARN] {relative_path} failed: {exc}")
        total_failures += failures
        print(f"Applied {relative_path}: statements={len(statements)} failures={failures}")

    if total_failures > 0:
        print(f"Completed with warnings. Total failures={total_failures}")
    else:
        print("Completed successfully with zero failures.")


if __name__ == "__main__":
    main()
