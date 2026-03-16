# Corporate Finance Actuarial Demo Talk Track

## Audience and Scope

- Audience: Corporate Finance Actuarial at Suncorp (not pricing actuarial, not operational claims actuarial).
- Goal: show how Databricks supports finance-actuarial controls, close readiness, portfolio insight, and governed self-service analytics.
- Environment: Field Engineering workspace, `corporate_finance` catalog.

## Session Structure (45 + 15)

1. Context and outcomes (5 min)
2. Data foundation and controls (12 min)
3. Live demo walkthrough (20 min)
4. SAS transition path and implementation plan (8 min)
5. Q&A (15 min)

## Demo Assets (Quick Access)

- Interactive demo guide: `docs/corporate_finance_demo_interactive.html`
- Copy-ready SQL worksheet: `docs/corporate_finance_demo_worksheet.sql`
- Tip: keep both open side-by-side during the live walkthrough.

## Opening Narrative (What to Say)

Use this framing:

`Today we are focused on Corporate Finance Actuarial outcomes: faster close-readiness insight, stronger controls and auditability, and near-real-time portfolio monitoring. This is not a pricing platform demo.`

## Customer Ask Coverage Matrix

## 1) Effective actuarial data structures across policy, claims, reinsurance, finance

Show:
- `corporate_finance.landing` for input data contracts.
- `corporate_finance.conformed_fin_actuarial` for standardised silver outputs.
- `corporate_finance.reporting_fin_actuarial` for finance-actuarial reporting products.
- `corporate_finance.quarantine_fin_actuarial` for failed rule handling.

Message:
- single governed model across the four source domains.
- consistent keys and as-at-date semantics for finance reporting.

## 2) Data dictionary and metadata catalogue

Show:
- schema/table comments from governance SQL.
- curated reporting views and clear business naming.
- Genie semantic views with business-oriented descriptions.

Message:
- business definitions are embedded in governed data assets, not hidden in spreadsheets.

## 3) Eliminate manual processes

Show:
- automated SQL/bootstrap flow and repeatable setup scripts.
- rule-driven quarantine and DQ summaries.

Message:
- manual stitching/reconciliation replaced by repeatable, auditable pipeline outputs.

## 4) Access live data (not only month-end)

Show:
- latest as-at-date data in reporting tables.
- `close_readiness_indicators` view for current operational readiness.

Message:
- same architecture supports periodic close and intra-period monitoring.

## 5) Automated quality checks and validation

Show:
- `dq_claims_summary`, `dq_policy_summary`, and `dq_trend_metrics`.
- quarantine tables with failed records.

Message:
- data quality is measurable, trendable, and operationalised.

## 6) Portfolio monitoring dashboards

Show:
- Lakeview dashboard: `Corporate Finance Actuarial Dashboard`.
- key reporting tables:
  - `valuation_movement_bridge`
  - `gross_to_net_liability_view`
  - `portfolio_trend_metrics`
  - `valuation_kpi_snapshot`

Message:
- portfolio-level finance-actuarial KPIs are available as governed dashboard assets.

## 7) AI/ML for trend/anomaly detection

Show:
- Genie benchmark artifacts:
  - `genie_benchmark_catalog`
  - `genie_benchmark_expected_results`
  - `genie_benchmark_evaluations`
- ask Genie space a live question and review generated SQL.

Message:
- AI is used as governed analytic acceleration, with benchmarked outputs and human validation.

## 8) SAS to Databricks transition approach

Talk track:
- Wave 1: parity outputs and reconciliation.
- Wave 2: automated controls and conformance.
- Wave 3: near-real-time monitoring and governed self-service.
- Wave 4: decommission legacy manual/SAS-heavy steps.

Show:
- workstream pack in `prompts/workstreams/` and phased roadmap.

## 9) Governance and compliance controls

Show:
- grants and schema controls (`20_governance_setup.sql` / `21_governance_verification.sql`).
- access boundaries by layer.
- table/view comments and lineage-ready modelling.

Message:
- governance is built in as a first-class control, not bolted on later.

## 10) Time travel and audit reproducibility

Show:
- `DESCRIBE HISTORY corporate_finance.reporting_fin_actuarial.valuation_movement_bridge`
- `VERSION AS OF` comparison query (`40_time_travel_demo.sql`).

Message:
- historical reproducibility supports audit and explains reporting changes over time.

## Live Demo Script (Step-by-Step)

1. Confirm catalog state:
   - show schemas in `corporate_finance`.
2. Show seeded data:
   - landing record counts and sample rows.
3. Show quality controls:
   - DQ summaries + quarantine examples.
4. Show reporting outputs:
   - movement bridge, gross/net view, close readiness.
5. Show time travel:
   - history and prior-version comparison.
6. Show dashboard:
   - open `Corporate Finance Actuarial Dashboard`.
7. Show Genie:
   - open `Corporate Finance Actuarial Genie`.
   - ask:
     - largest liability movement
     - highest DQ failures
   - show SQL trace and response.
8. Close with transition path:
   - summarise SAS migration waves and control checkpoints.

## Suggested Q&A Responses

- **Is this a pricing solution?**
  - No. This demo is Corporate Finance Actuarial focused: valuation movement, controls, quality, and close readiness.
- **How do we trust AI answers?**
  - Genie is constrained to curated governed views and benchmarked questions with expected-result validation.
- **How do we support audit?**
  - Governance controls, DQ evidence, and Delta history/time-travel provide reproducibility.
- **Can this run in our FE workspace?**
  - Yes, all assets are implemented in `corporate_finance` in the FE workspace.

## Demo Completion Checklist

- [ ] Corporate Finance Genie space responds successfully.
- [ ] Dashboard is published and accessible.
- [ ] DQ summaries and quarantine records visible.
- [ ] Time-travel query demonstrates prior version access.
- [ ] Benchmark tables populated for Genie evidence.
- [ ] Transition roadmap and workstreams reviewed.
