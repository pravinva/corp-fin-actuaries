# WS02 SAS Estate Discovery

## Objective and Business Outcomes
- Build a complete inventory of SAS assets used by Corporate Finance Actuarial.
- Create a migration-ready backlog with risk, complexity, and sequencing.

## In Scope
- SAS jobs, datasets, macros, schedules, dependencies, and manual touchpoints.
- Input/output mapping to target Gold data products.
- Wave planning by criticality and migration complexity.

## Out of Scope
- Migration build itself (covered by WS11).

## Inputs and Dependencies
- Inputs: SAS repository access, scheduler metadata, SME interviews, month-end runbooks.
- Dependencies: availability of actuarial SMEs and legacy support team.

## Detailed Task Backlog (Sequenced)
1. Extract technical inventory from SAS environments.
2. Run business workshops to map outputs to Corporate Finance Actuarial use cases.
3. Identify manual steps, spreadsheets, and file handoffs.
4. Score each workload by criticality, complexity, and automation potential.
5. Produce migration wave plan and validate with stakeholders.

## Deliverables
- SAS asset inventory.
- Manual process map.
- Workload classification matrix.
- Migration wave plan with estimates.

## RACI-lite
- Accountable: Corporate Finance Actuarial domain owner.
- Responsible: Migration lead and SAS SMEs.
- Consulted: Data engineering, FE, finance control teams.
- Informed: Program governance forum.

## Risks and Mitigations
- Risk: Hidden manual dependencies appear late.
  - Mitigation: perform shadow-run observation during close cycle.
- Risk: Incomplete metadata from legacy tools.
  - Mitigation: combine automated extraction with SME validation.

## Exit Criteria / Acceptance Criteria
- 100% in-scope SAS workloads inventoried and owner-assigned.
- Wave assignment approved by business and program governance.

## Demo Evidence Required for Sign-off
- Inventory dashboard showing workload count, criticality, and wave allocation.
