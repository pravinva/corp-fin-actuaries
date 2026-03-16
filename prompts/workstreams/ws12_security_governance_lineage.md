# WS12 Security Governance and Lineage

## Objective and Business Outcomes
- Ensure data access, governance, and lineage controls meet finance and audit expectations.
- Provide end-to-end evidence from source ingestion to reporting consumption.

## In Scope
- Role and entitlement design based on least privilege.
- Lineage visibility for key data products and reports.
- Governance controls for sensitive fields and access audits.

## Out of Scope
- End-user training content beyond control model explanation.

## Inputs and Dependencies
- Inputs: WS05 Gold products, WS06 metadata standards, WS07 controls.
- Dependencies: security policy decisions and environment strategy.

## Detailed Task Backlog (Sequenced)
1. Define role model by producer, steward, and consumer groups.
2. Configure object ownership, grants, and environment separation controls.
3. Enable lineage capture and map key KPI dependencies.
4. Implement control checks for entitlements and policy exceptions.
5. Prepare governance evidence pack for risk and audit review.

## Deliverables
- Security and entitlement matrix.
- Lineage mapping for priority reports and KPIs.
- Governance evidence pack and policy exception register.

## RACI-lite
- Accountable: Security and governance lead.
- Responsible: Platform admin and governance engineering.
- Consulted: Risk, audit, legal/compliance, and Corporate Finance Actuarial.
- Informed: program governance forum.

## Risks and Mitigations
- Risk: overly broad access conflicts with least privilege.
  - Mitigation: role-based entitlement reviews and quarterly recertification.
- Risk: incomplete lineage coverage for critical metrics.
  - Mitigation: lineage completeness checks as release gate.

## Exit Criteria / Acceptance Criteria
- Security role model approved and implemented.
- Governance and lineage evidence accepted by control stakeholders.

## Demo Evidence Required for Sign-off
- Show user-role access boundaries and lineage path for one executive KPI.
