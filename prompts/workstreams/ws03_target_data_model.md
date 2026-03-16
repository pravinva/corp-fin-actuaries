# WS03 Target Data Model

## Objective and Business Outcomes
- Define a Corporate Finance Actuarial target model for policy, claims, reinsurance, and finance data.
- Provide a stable foundation for controls, reporting, and migration from SAS.

## In Scope
- Conceptual, logical, and physical model definitions.
- Bronze, Silver, Gold data product structure and naming standards.
- Canonical keys and conformance rules.

## Out of Scope
- Source ingestion configuration and operational scheduling.

## Inputs and Dependencies
- Inputs: WS02 inventory outputs, finance reporting requirements, actuarial definitions.
- Dependencies: business agreement on KPI definitions and portfolio hierarchy.

## Detailed Task Backlog (Sequenced)
1. Define conceptual model by business domain and data ownership.
2. Create logical model with keys, relationships, and conformance attributes.
3. Define physical model standards for Bronze, Silver, and Gold.
4. Document naming conventions and schema management rules.
5. Validate model with business and controls stakeholders.

## Deliverables
- Target domain model pack.
- Naming and schema standards.
- Conformance key dictionary.
- Model sign-off record.

## RACI-lite
- Accountable: Data architecture lead.
- Responsible: Data modeller and domain data engineer.
- Consulted: Corporate Finance Actuarial, finance data stewards, FE.
- Informed: Program governance forum.

## Risks and Mitigations
- Risk: Divergent business definitions across teams.
  - Mitigation: glossary-driven sign-off workshops and conflict resolution board.
- Risk: Over-normalised model slows consumption.
  - Mitigation: balance canonical model with analytics-friendly Gold views.

## Exit Criteria / Acceptance Criteria
- Signed conceptual/logical/physical model baseline.
- Approved conformance keys and naming conventions.

## Demo Evidence Required for Sign-off
- Model walkthrough showing source-to-Gold mapping for one representative KPI.
