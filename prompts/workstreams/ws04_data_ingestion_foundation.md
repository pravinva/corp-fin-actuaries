# WS04 Data Ingestion Foundation

## Objective and Business Outcomes
- Establish a reusable ingestion framework for policy, claims, reinsurance, and finance sources.
- Reduce manual data loading and create controlled, repeatable ingestion behaviour.

## In Scope
- Source onboarding patterns for batch, incremental, and reference data.
- Ingestion controls: completeness, schema drift, watermarking, replay.
- Operational standards for failures, retries, and alerts.

## Out of Scope
- Silver/Gold transformation logic and dashboard build.

## Inputs and Dependencies
- Inputs: target model from WS03 and source inventory from WS02.
- Dependencies: source data access, credentials, and extract schedules.

## Detailed Task Backlog (Sequenced)
1. Define source onboarding checklist and ingestion contract template.
2. Build generic ingestion patterns for full, incremental, and reference loads.
3. Implement technical controls for schema drift and duplicate detection.
4. Implement control tables for run status, watermark, and replay metadata.
5. Define failure handling and support handoff process.

## Deliverables
- Ingestion onboarding playbook.
- Reusable ingestion framework patterns.
- Run control and replay strategy document.
- Source-level SLA and alert definitions.

## RACI-lite
- Accountable: Platform delivery lead.
- Responsible: Data engineering team.
- Consulted: Source system owners, FE, operations team.
- Informed: Corporate Finance Actuarial stakeholders.

## Risks and Mitigations
- Risk: source extract latency prevents near-real-time goals.
  - Mitigation: negotiate source SLAs and deploy latest-available indicators.
- Risk: frequent schema changes cause pipeline instability.
  - Mitigation: enforce schema change protocol and compatibility checks.

## Exit Criteria / Acceptance Criteria
- Pilot source sets loading through reusable framework.
- Run controls and replay process tested and documented.

## Demo Evidence Required for Sign-off
- End-to-end ingestion run with traceable status and replay of one failed batch.
