# FE Handover Runbook

## Purpose
Define the minimum handover package for Field Engineering to run and support the Corporate Finance Actuarial solution in the target workspace.

## Handover Contents
1. Program and architecture baseline
   - Roadmap and dependency map.
   - Current scope and out-of-scope boundaries.
2. Data product inventory
   - Gold products, ownership, and refresh cadence.
   - Known limitations and open risks.
3. Operational procedures
   - Pipeline monitoring, retries, and replay process.
   - Data quality breach triage and escalation.
4. Governance and controls
   - Access model and privileged operations.
   - Lineage and audit evidence retrieval.
5. Consumer support
   - Dashboard support and publication controls.
   - Genie scope, trusted query set, and guardrails.

## Day-1 Operations
- Validate overnight and intra-day runs.
- Review critical DQ breaches and freshness SLA status.
- Confirm dashboard refresh and subscription execution.
- Confirm incident channel and support roster activation.

## Day-7 Stabilisation Review
- Review incident trends and SLA compliance.
- Review false-positive rate for anomaly alerts.
- Confirm backlog of defects and enhancement requests.
- Adjust operational thresholds and alert routing where needed.

## Escalation Model
- P1 (reporting outage, critical data integrity): immediate escalation to platform owner and business owner.
- P2 (degraded freshness, partial failures): resolve in same business day with owner assignment.
- P3 (non-blocking defects): route to backlog with target release.

## Handover Acceptance Criteria
- FE team can execute all daily checks without shadow support.
- FE team can run replay and breach triage drills successfully.
- FE team can provide evidence for one KPI lineage and one access audit.
