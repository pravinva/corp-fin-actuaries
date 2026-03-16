# Demo Runbook: Governance, Quality, Time Travel, and Genie

This runbook provides a structured demonstration for Corporate Finance Actuarial audiences.

## Demo Outcomes
- Prove governance controls and access boundaries.
- Show automated data quality monitoring and quarantine handling.
- Demonstrate Delta time travel for historical reproducibility.
- Show Genie-based analysis on curated, governance-aware assets.

## Demo Sequence

1. **Run setup and pipeline**
   - Execute `src/sql/00_create_schemas.sql`.
   - Run the pipeline (`python scripts/run_pipeline.py`) at least twice with changed source input.

2. **Governance controls**
   - Execute `src/sql/20_governance_setup.sql`.
   - Execute `src/sql/21_governance_verification.sql`.
   - Show grants, schema comments, and table metadata.

3. **Data quality controls**
   - Execute `src/sql/30_quality_monitoring_queries.sql`.
   - Show latest DQ summaries, quarantine counts, and trend view.

4. **Delta time travel**
   - Execute `src/sql/40_time_travel_demo.sql`.
   - Show current vs previous snapshot and movement deltas.

5. **Genie enablement**
   - Execute `src/sql/50_genie_setup.sql`.
   - Configure Genie space using `prompts/workstreams/genie_space_authoring_guide.md`.
   - Run benchmark questions and show response traceability.

## Evidence Checklist
- Governance evidence: grants and metadata comments.
- Quality evidence: failed record counts and quarantine trend.
- Time travel evidence: historical snapshot query results.
- Genie evidence: benchmark accuracy and business-context alignment.
