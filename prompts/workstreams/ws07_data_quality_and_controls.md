# WS07 Data Quality and Controls

## Objective and Business Outcomes
- Embed automated data quality and control checks across ingestion, conformance, and Gold outputs.
- Reduce manual reconciliations and improve confidence in reporting outputs.

## In Scope
- DQ rule framework and severity model.
- Exception triage and remediation workflow.
- DQ scorecards and control reporting.

## Out of Scope
- Business dashboard design and consumption experiences.

## Inputs and Dependencies
- Inputs: WS04 ingestion controls, WS05 Gold products, WS06 dictionary standards.
- Dependencies: control owner assignments and incident management process.

## Detailed Task Backlog (Sequenced)
1. Define rule taxonomy: ingestion, conformance, and business validation checks.
2. Classify rules using severity levels (`warn`, `drop`, `fail`).
3. Build exception logging and ownership assignment model.
4. Implement DQ scorecards, breach trend, and ageing views.
5. Validate control effectiveness through scenario-based test packs.

## Deliverables
- DQ rule library and ownership matrix.
- Exception and remediation workflow.
- DQ control scorecard and reporting views.

## RACI-lite
- Accountable: Data control owner.
- Responsible: Data engineering and data steward teams.
- Consulted: Corporate Finance Actuarial, risk, and audit.
- Informed: finance reporting stakeholders.

## Risks and Mitigations
- Risk: too many critical failures block daily runs.
  - Mitigation: calibrate thresholds and apply phased hardening.
- Risk: unresolved breaches accumulate.
  - Mitigation: enforce breach SLAs and escalation policy.

## Exit Criteria / Acceptance Criteria
- Control coverage target met for in-scope data products.
- Breach handling workflow operational with assigned owners.

## Demo Evidence Required for Sign-off
- Demo of failed quality rule, exception triage, fix, and successful rerun.
