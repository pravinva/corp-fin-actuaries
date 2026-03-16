# Bootstrap and Benchmark Runbook

This runbook creates all demo data and benchmark evidence required for governance, quality, time travel, and Genie demonstrations.

## 1) Create Schemas
Run:
- `src/sql/00_create_schemas.sql`

## 2) Build Demo Data and Pipeline Outputs
Run:
- `python3 scripts/build_demo_state.py`

This creates and populates:
- Landing tables:
  - `corp_fin_actuarial.landing.policy_extract`
  - `corp_fin_actuarial.landing.claims_extract`
  - `corp_fin_actuarial.landing.reinsurance_extract`
  - `corp_fin_actuarial.landing.finance_extract`
- Conformed tables:
  - `corp_fin_actuarial.conformed_fin_actuarial.policy_silver`
  - `corp_fin_actuarial.conformed_fin_actuarial.claims_silver`
- Quarantine tables:
  - `corp_fin_actuarial.quarantine_fin_actuarial.policy_dq_quarantine`
  - `corp_fin_actuarial.quarantine_fin_actuarial.claims_dq_quarantine`
- Reporting tables:
  - `corp_fin_actuarial.reporting_fin_actuarial.valuation_movement_bridge`
  - `corp_fin_actuarial.reporting_fin_actuarial.gross_to_net_liability_view`
  - `corp_fin_actuarial.reporting_fin_actuarial.close_readiness_indicators`
  - `corp_fin_actuarial.reporting_fin_actuarial.valuation_movement_snapshots`
  - `corp_fin_actuarial.reporting_fin_actuarial.dq_claims_summary`
  - `corp_fin_actuarial.reporting_fin_actuarial.dq_policy_summary`

The script runs twice with changed parameters to produce multiple Delta versions for time-travel demos.

## 3) Governance, DQ, Time Travel, and Genie SQL
Run in order:
1. `src/sql/20_governance_setup.sql`
2. `src/sql/21_governance_verification.sql`
3. `src/sql/30_quality_monitoring_queries.sql`
4. `src/sql/40_time_travel_demo.sql`
5. `src/sql/50_genie_setup.sql`
6. `src/sql/51_genie_benchmark_tables.sql`

## 4) Build Genie Benchmark Evidence
Run:
- `python3 scripts/genie_benchmark_runner.py`

This populates:
- `corp_fin_actuarial.reporting_fin_actuarial.genie_benchmark_catalog`
- `corp_fin_actuarial.reporting_fin_actuarial.genie_benchmark_expected_results`

## 5) Record Evaluation Results
Use:
- `scripts/genie_benchmark_evaluator_template.sql`

Insert one row per benchmark question after manual Genie evaluation.
