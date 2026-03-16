-- Corporate Finance Actuarial governance setup.
-- Replace principal names with your Databricks account-level groups.

GRANT USE CATALOG ON CATALOG corp_fin_actuarial TO `corp_fin_actuarial_users`;

-- Raw layer is restricted to engineering and platform teams.
GRANT USE SCHEMA ON SCHEMA corp_fin_actuarial.raw_fin_actuarial TO `corp_fin_actuarial_engineers`;
GRANT SELECT ON SCHEMA corp_fin_actuarial.raw_fin_actuarial TO `corp_fin_actuarial_engineers`;

-- Conformed layer is available to producers and analysts.
GRANT USE SCHEMA ON SCHEMA corp_fin_actuarial.conformed_fin_actuarial TO `corp_fin_actuarial_analysts`;
GRANT SELECT ON SCHEMA corp_fin_actuarial.conformed_fin_actuarial TO `corp_fin_actuarial_analysts`;

-- Reporting layer is available to finance consumers.
GRANT USE SCHEMA ON SCHEMA corp_fin_actuarial.reporting_fin_actuarial TO `corp_fin_actuarial_users`;
GRANT SELECT ON SCHEMA corp_fin_actuarial.reporting_fin_actuarial TO `corp_fin_actuarial_users`;

-- Quarantine layer is restricted to DQ operations.
GRANT USE SCHEMA ON SCHEMA corp_fin_actuarial.quarantine_fin_actuarial TO `corp_fin_actuarial_dq_admins`;
GRANT SELECT ON SCHEMA corp_fin_actuarial.quarantine_fin_actuarial TO `corp_fin_actuarial_dq_admins`;

-- Governance intent documented in comments for discoverability.
COMMENT ON SCHEMA corp_fin_actuarial.raw_fin_actuarial IS
'Raw policy, claims, reinsurance and finance landed data. Restricted access.';
COMMENT ON SCHEMA corp_fin_actuarial.conformed_fin_actuarial IS
'Conformed actuarial-finance data for reusable enterprise consumption.';
COMMENT ON SCHEMA corp_fin_actuarial.reporting_fin_actuarial IS
'Gold reporting layer for Corporate Finance Actuarial dashboards and Genie spaces.';
COMMENT ON SCHEMA corp_fin_actuarial.quarantine_fin_actuarial IS
'Data quality quarantine for failed validation records requiring triage.';
