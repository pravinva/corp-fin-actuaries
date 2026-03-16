-- Corporate Finance Actuarial governance setup.
-- Replace principal names with your Databricks account-level groups.

GRANT USE CATALOG ON CATALOG corporate_finance TO `users`;

-- Landing schema is operational input zone.
GRANT USE SCHEMA ON SCHEMA corporate_finance.landing TO `users`;
GRANT SELECT ON SCHEMA corporate_finance.landing TO `users`;

-- Raw layer is restricted to engineering and platform teams.
GRANT USE SCHEMA ON SCHEMA corporate_finance.raw_fin_actuarial TO `users`;
GRANT SELECT ON SCHEMA corporate_finance.raw_fin_actuarial TO `users`;

-- Conformed layer is available to producers and analysts.
GRANT USE SCHEMA ON SCHEMA corporate_finance.conformed_fin_actuarial TO `users`;
GRANT SELECT ON SCHEMA corporate_finance.conformed_fin_actuarial TO `users`;

-- Reporting layer is available to finance consumers.
GRANT USE SCHEMA ON SCHEMA corporate_finance.reporting_fin_actuarial TO `users`;
GRANT SELECT ON SCHEMA corporate_finance.reporting_fin_actuarial TO `users`;

-- Quarantine layer is restricted to DQ operations.
GRANT USE SCHEMA ON SCHEMA corporate_finance.quarantine_fin_actuarial TO `users`;
GRANT SELECT ON SCHEMA corporate_finance.quarantine_fin_actuarial TO `users`;

-- Governance intent documented in comments for discoverability.
COMMENT ON SCHEMA corporate_finance.raw_fin_actuarial IS
'Raw policy, claims, reinsurance and finance landed data. Restricted access.';
COMMENT ON SCHEMA corporate_finance.landing IS
'Landing input zone for synthetic and source extracts before conformance pipeline.';
COMMENT ON SCHEMA corporate_finance.conformed_fin_actuarial IS
'Conformed actuarial-finance data for reusable enterprise consumption.';
COMMENT ON SCHEMA corporate_finance.reporting_fin_actuarial IS
'Gold reporting layer for Corporate Finance Actuarial dashboards and Genie spaces.';
COMMENT ON SCHEMA corporate_finance.quarantine_fin_actuarial IS
'Data quality quarantine for failed validation records requiring triage.';
