# Bootstrap and Benchmark Runbook

This runbook creates all demo data and benchmark evidence required for governance, quality, time travel, and Genie demonstrations in the `corporate_finance` catalog.

## 1) Execute the full SQL setup from local using DEFAULT profile
Run:
- `python3 scripts/execute_sql_via_warehouse.py`

This creates and populates:
- Landing tables:
  - `corporate_finance.landing.policy_extract`
  - `corporate_finance.landing.claims_extract`
  - `corporate_finance.landing.reinsurance_extract`
  - `corporate_finance.landing.finance_extract`
- Conformed tables:
  - `corporate_finance.conformed_fin_actuarial.policy_silver`
  - `corporate_finance.conformed_fin_actuarial.claims_silver`
- Quarantine tables:
  - `corporate_finance.quarantine_fin_actuarial.policy_dq_quarantine`
  - `corporate_finance.quarantine_fin_actuarial.claims_dq_quarantine`
- Reporting tables:
  - `corporate_finance.reporting_fin_actuarial.valuation_movement_bridge`
  - `corporate_finance.reporting_fin_actuarial.gross_to_net_liability_view`
  - `corporate_finance.reporting_fin_actuarial.close_readiness_indicators`
  - `corporate_finance.reporting_fin_actuarial.valuation_movement_snapshots`
  - `corporate_finance.reporting_fin_actuarial.dq_claims_summary`
  - `corporate_finance.reporting_fin_actuarial.dq_policy_summary`

The SQL seed process creates multiple versions of `valuation_movement_bridge` so time-travel queries can be demonstrated immediately.

## 2) Optional bundle-based execution in workspace jobs
If you prefer running in Databricks Jobs:
- Deploy bundle with `databricks bundle deploy --profile DEFAULT -t dev`
- Run `corporate_finance_sql_setup` job

## 3) Build Genie Benchmark Evidence
`scripts/execute_sql_via_warehouse.py` includes:
- `src/sql/51_genie_benchmark_tables.sql`
- `src/sql/52_seed_genie_benchmarks.sql`

This populates:
- `corporate_finance.reporting_fin_actuarial.genie_benchmark_catalog`
- `corporate_finance.reporting_fin_actuarial.genie_benchmark_expected_results`

## 4) Record Evaluation Results
Use:
- `scripts/genie_benchmark_evaluator_template.sql`

Insert one row per benchmark question after manual Genie evaluation.
