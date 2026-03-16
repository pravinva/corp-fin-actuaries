# WS11 SAS Transition Factory

## Objective and Business Outcomes
- Deliver a controlled migration from SAS to Databricks with parity assurance and business continuity.
- Minimise cutover risk while reducing technical debt and manual effort.

## In Scope
- Wave-based migration factory model.
- Dual-run reconciliation and tolerance controls.
- Cutover and rollback planning.

## Out of Scope
- Net-new use-case expansion beyond approved migration scope.

## Inputs and Dependencies
- Inputs: WS02 inventory and wave plan, WS05/WS07 outputs.
- Dependencies: business sign-off resources and legacy runtime access.

## Detailed Task Backlog (Sequenced)
1. Confirm migration waves and prioritised workloads.
2. Define conversion patterns for SAS jobs/macros to Databricks equivalents.
3. Execute dual-run cycles and reconcile outputs by agreed tolerances.
4. Resolve variances with documented root cause and remediation.
5. Execute cutover readiness review and rollback drill.

## Deliverables
- Migration factory playbook.
- Wave-by-wave conversion backlog.
- Dual-run reconciliation pack.
- Cutover and rollback checklist.

## RACI-lite
- Accountable: Migration program lead.
- Responsible: SAS conversion squad and data engineering team.
- Consulted: Corporate Finance Actuarial SMEs, risk, and FE.
- Informed: governance and executive stakeholders.

## Risks and Mitigations
- Risk: hidden SAS logic causes parity issues.
  - Mitigation: detailed lineage mapping and SME code walkthroughs.
- Risk: extended dual-run drives schedule slip.
  - Mitigation: timeboxed variance triage and escalation criteria.

## Exit Criteria / Acceptance Criteria
- Reconciliation parity achieved for in-scope wave.
- Cutover and rollback procedures approved.

## Demo Evidence Required for Sign-off
- Demonstrate one migrated workload with parity report and signed variance disposition.
