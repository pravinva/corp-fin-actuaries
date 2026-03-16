-- Governance verification queries for demo evidence.

-- 1) Validate grants at catalog and schema level.
SHOW GRANTS ON CATALOG corp_fin_actuarial;
SHOW GRANTS ON SCHEMA corp_fin_actuarial.landing;
SHOW GRANTS ON SCHEMA corp_fin_actuarial.raw_fin_actuarial;
SHOW GRANTS ON SCHEMA corp_fin_actuarial.conformed_fin_actuarial;
SHOW GRANTS ON SCHEMA corp_fin_actuarial.reporting_fin_actuarial;
SHOW GRANTS ON SCHEMA corp_fin_actuarial.quarantine_fin_actuarial;

-- 2) Confirm schema comments (governance metadata).
DESCRIBE SCHEMA EXTENDED corp_fin_actuarial.raw_fin_actuarial;
DESCRIBE SCHEMA EXTENDED corp_fin_actuarial.reporting_fin_actuarial;

-- 3) Confirm table comments can be used as metadata for business users and Genie context.
COMMENT ON TABLE corp_fin_actuarial.reporting_fin_actuarial.valuation_movement_bridge IS
'Corporate Finance Actuarial valuation movement bridge by portfolio and as-at date.';
COMMENT ON TABLE corp_fin_actuarial.reporting_fin_actuarial.gross_to_net_liability_view IS
'Gross and net liability view with reinsurance impacts by portfolio and as-at date.';
COMMENT ON TABLE corp_fin_actuarial.reporting_fin_actuarial.close_readiness_indicators IS
'Close readiness control flags for portfolio data completeness.';

DESCRIBE EXTENDED corp_fin_actuarial.reporting_fin_actuarial.valuation_movement_bridge;
