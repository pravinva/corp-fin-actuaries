# WS05 Conformance and Gold Products

## Objective and Business Outcomes
- Convert ingested source data into conformed Silver assets and finance-actuarial Gold products.
- Provide trusted and reusable data products for valuation monitoring and reporting.

## In Scope
- Silver conformance logic for keys, dimensions, and reference mappings.
- Gold products for Corporate Finance Actuarial reporting and monitoring.
- Reconciliation and validation against business definitions.

## Out of Scope
- Consumer dashboards and NLQ interfaces (covered in WS09).

## Inputs and Dependencies
- Inputs: WS03 model standards and WS04 ingestion outputs.
- Dependencies: dictionary definitions from WS06 and DQ controls from WS07.

## Detailed Task Backlog (Sequenced)
1. Build Silver conformance tables with standard portfolio, legal entity, and calendar dimensions.
2. Implement gross and net data structures linking reinsurance impacts.
3. Create Gold data products:
   - valuation movement bridge
   - gross-to-net liability view
   - close readiness indicators
   - portfolio trend metrics
4. Validate and reconcile Gold outputs with business SMEs.
5. Publish data product contracts for downstream consumption.

## Deliverables
- Silver conformance dataset pack.
- Gold data product set with owner and refresh metadata.
- Reconciliation and sign-off report.

## RACI-lite
- Accountable: Data product owner.
- Responsible: Transformation engineering team.
- Consulted: Corporate Finance Actuarial SMEs, controls and finance teams.
- Informed: program governance forum.

## Risks and Mitigations
- Risk: ambiguous business definitions block sign-off.
  - Mitigation: tie each Gold metric to approved dictionary entry.
- Risk: high-volume joins affect performance.
  - Mitigation: optimise partitioning and incremental transformation patterns.

## Exit Criteria / Acceptance Criteria
- Gold products complete and signed off by Corporate Finance Actuarial.
- Reconciliation results within agreed tolerance.

## Demo Evidence Required for Sign-off
- Demonstrate one end-to-end metric lineage from raw source to Gold output.
