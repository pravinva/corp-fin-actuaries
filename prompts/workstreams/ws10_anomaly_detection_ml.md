# WS10 Anomaly Detection ML

## Objective and Business Outcomes
- Deploy non-agentic anomaly detection to flag emerging changes in portfolio trends.
- Support Corporate Finance Actuarial review workflows with explainable signals.

## In Scope
- Feature preparation from Gold trend and movement datasets.
- Baseline anomaly models and threshold tuning.
- Alerting and human-review process for flagged records.

## Out of Scope
- Automated decisioning or model-driven sign-off.

## Inputs and Dependencies
- Inputs: WS05 Gold metrics, WS08 operations, WS09 consumption requirements.
- Dependencies: historical data depth and approved alert routing model.

## Detailed Task Backlog (Sequenced)
1. Select target monitoring signals and define anomaly taxonomy.
2. Prepare training and validation datasets from curated Gold assets.
3. Train baseline detection models and evaluate false-positive rates.
4. Implement explainability fields and confidence indicators.
5. Integrate anomaly outputs into dashboard and triage workflow.

## Deliverables
- Anomaly monitoring dataset and feature definitions.
- Baseline model package and evaluation report.
- Alert and review workflow integrated into operations.

## RACI-lite
- Accountable: Analytics product owner.
- Responsible: Data science and ML engineering team.
- Consulted: Corporate Finance Actuarial SMEs and controls teams.
- Informed: operations and governance forums.

## Risks and Mitigations
- Risk: false positives reduce trust and actionability.
  - Mitigation: threshold calibration and staged rollout by domain.
- Risk: concept drift reduces model quality.
  - Mitigation: periodic retraining and drift monitoring.

## Exit Criteria / Acceptance Criteria
- Backtesting and validation thresholds approved.
- Review workflow adopted by business users.

## Demo Evidence Required for Sign-off
- Show anomaly detection on historical data with explained outcomes and reviewer actions.
