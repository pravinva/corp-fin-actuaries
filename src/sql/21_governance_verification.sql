-- Governance verification queries for demo evidence.

-- 1) Validate grants at catalog and schema level.
SHOW GRANTS ON CATALOG corporate_finance;
SHOW GRANTS ON SCHEMA corporate_finance.landing;
SHOW GRANTS ON SCHEMA corporate_finance.raw_fin_actuarial;
SHOW GRANTS ON SCHEMA corporate_finance.conformed_fin_actuarial;
SHOW GRANTS ON SCHEMA corporate_finance.reporting_fin_actuarial;
SHOW GRANTS ON SCHEMA corporate_finance.quarantine_fin_actuarial;

-- 2) Confirm schema comments (governance metadata).
DESCRIBE SCHEMA EXTENDED corporate_finance.raw_fin_actuarial;
DESCRIBE SCHEMA EXTENDED corporate_finance.reporting_fin_actuarial;

-- 3) Confirm table comments can be used as metadata for business users and Genie context.
COMMENT ON TABLE corporate_finance.reporting_fin_actuarial.valuation_movement_bridge IS
'Corporate Finance Actuarial valuation movement bridge by portfolio and as-at date.';
COMMENT ON TABLE corporate_finance.reporting_fin_actuarial.gross_to_net_liability_view IS
'Gross and net liability view with reinsurance impacts by portfolio and as-at date.';
COMMENT ON TABLE corporate_finance.reporting_fin_actuarial.close_readiness_indicators IS
'Close readiness control flags for portfolio data completeness.';

DESCRIBE EXTENDED corporate_finance.reporting_fin_actuarial.valuation_movement_bridge;
