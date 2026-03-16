# WS08 Live Data and Pipeline Operations

## Objective and Business Outcomes
- Shift from month-end-only views to latest-available intra-period data access.
- Establish stable pipeline operations with clear SLAs and observability.

## In Scope
- Orchestration and scheduling standards.
- Freshness SLAs, alerting, and runbook-driven operations.
- Replay and incident response practices.

## Out of Scope
- Portfolio dashboard design and anomaly model development.

## Inputs and Dependencies
- Inputs: WS04 ingestion framework and WS07 control framework.
- Dependencies: source update frequency and operational support model.

## Detailed Task Backlog (Sequenced)
1. Define tiered refresh frequencies by data domain and business criticality.
2. Implement pipeline schedules for intra-day and daily processing.
3. Build freshness monitoring and SLA breach alerts.
4. Define rerun, replay, and incident classification process.
5. Publish operations runbook and handover protocol.

## Deliverables
- Pipeline operations standard.
- Data freshness SLA matrix.
- Monitoring and alerting dashboard.
- Incident and replay runbook.

## RACI-lite
- Accountable: Operations lead.
- Responsible: Platform operations and data engineering.
- Consulted: Corporate Finance Actuarial and source system owners.
- Informed: program governance forum.

## Risks and Mitigations
- Risk: source delivery windows are inconsistent.
  - Mitigation: latest-available flags and source SLA governance.
- Risk: alert noise causes missed critical incidents.
  - Mitigation: severity routing and alert deduplication.

## Exit Criteria / Acceptance Criteria
- Freshness SLA met for pilot data products.
- Operations runbook tested through simulation drills.

## Demo Evidence Required for Sign-off
- Show current freshness status and a controlled incident replay scenario.
