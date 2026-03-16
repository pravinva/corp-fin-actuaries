# Corporate Finance Actuarial on Databricks

This repository contains planning artifacts and implementation scaffolding for a Corporate Finance Actuarial platform on Databricks.

## Repository Structure

- `prompts/workstreams/`: program workstreams, roadmap, templates, and FE rollout pack.
- `src/config/`: source and environment configuration templates.
- `src/pipelines/`: ingestion, conformance, and DQ pipeline code.
- `src/sql/`: SQL DDL and Gold reporting view templates.
- `scripts/`: local helper scripts for running pipeline entry points.
- `docs/`: demonstration runbooks and rollout notes.

## Implementation Focus

The initial code scaffold supports:

- ingestion contracts for policy, claims, reinsurance, and finance inputs
- conformance into Silver-style datasets
- quality checks with quarantine handling and rule summary outputs
- Gold-ready output tables and reporting view definitions
- governance setup and verification SQL patterns
- Delta time-travel demonstration queries
- Genie-ready curated semantic views and authoring guide

## Quick Start

1. Review source definitions in `src/config/sources.yml`.
2. Configure Databricks paths and catalog/schema values in `src/config/runtime_config.py`.
3. Run the pipeline entry point:
   - `python scripts/run_pipeline.py`
4. Execute SQL setup scripts in `src/sql/` within your Databricks workspace.

## Demo Pack

- Governance setup: `src/sql/20_governance_setup.sql`
- Governance verification: `src/sql/21_governance_verification.sql`
- Data quality monitoring: `src/sql/30_quality_monitoring_queries.sql`
- Delta time travel: `src/sql/40_time_travel_demo.sql`
- Genie semantic setup: `src/sql/50_genie_setup.sql`
- Genie authoring guide: `prompts/workstreams/genie_space_authoring_guide.md`
- End-to-end runbook: `docs/governance_quality_timetravel_genie_demo.md`

## Notes

- This scaffold is intentionally implementation-friendly for Field Engineering.
- It is designed to be extended into full Lakeflow/Jobs deployment during delivery waves.
