-- Genie-ready curated semantic views and metadata.
-- Use these assets when building the Corporate Finance Actuarial Genie space.

CREATE OR REPLACE VIEW corp_fin_actuarial.reporting_fin_actuarial.genie_finance_actuarial_metrics AS
SELECT
  v.portfolio_code,
  v.as_at_date,
  v.opening_liability,
  v.closing_liability,
  v.movement_amount,
  v.movement_ratio,
  g.gross_claim_amount,
  g.net_claim_amount,
  g.reinsurance_impact,
  c.close_readiness_flag
FROM corp_fin_actuarial.reporting_fin_actuarial.valuation_movement_bridge v
LEFT JOIN corp_fin_actuarial.reporting_fin_actuarial.gross_to_net_liability_view g
  ON v.portfolio_code = g.portfolio_code
 AND v.as_at_date = g.as_at_date
LEFT JOIN corp_fin_actuarial.reporting_fin_actuarial.close_readiness_indicators c
  ON v.as_at_date = c.as_at_date;

COMMENT ON VIEW corp_fin_actuarial.reporting_fin_actuarial.genie_finance_actuarial_metrics IS
'Curated semantic view for Genie. One-stop portfolio movement, gross/net, reinsurance impact, and close readiness.';

COMMENT ON COLUMN corp_fin_actuarial.reporting_fin_actuarial.genie_finance_actuarial_metrics.movement_amount IS
'Period movement in liability amount for a given portfolio and as-at date.';
COMMENT ON COLUMN corp_fin_actuarial.reporting_fin_actuarial.genie_finance_actuarial_metrics.reinsurance_impact IS
'Difference between gross and net claim amount, representing reinsurance effect.';
COMMENT ON COLUMN corp_fin_actuarial.reporting_fin_actuarial.genie_finance_actuarial_metrics.close_readiness_flag IS
'Boolean indicator that policy and claims data are both present for close readiness.';

-- Optional helper view for quality-aware Genie questions.
CREATE OR REPLACE VIEW corp_fin_actuarial.reporting_fin_actuarial.genie_dq_status AS
SELECT
  dataset_name,
  dq_run_timestamp,
  total_record_count,
  COALESCE(dq_claim_amount_non_negative_fail_count, 0) AS claim_amount_fail_count,
  COALESCE(dq_report_after_loss_fail_count, 0) AS report_after_loss_fail_count,
  COALESCE(dq_claim_id_present_fail_count, 0) AS claim_id_fail_count,
  COALESCE(dq_policy_id_present_fail_count, 0) AS policy_id_fail_count,
  COALESCE(dq_inception_before_expiry_fail_count, 0) AS inception_expiry_fail_count
FROM (
  SELECT * FROM corp_fin_actuarial.reporting_fin_actuarial.dq_claims_summary
  UNION ALL
  SELECT * FROM corp_fin_actuarial.reporting_fin_actuarial.dq_policy_summary
);

COMMENT ON VIEW corp_fin_actuarial.reporting_fin_actuarial.genie_dq_status IS
'Curated data quality status view for Genie questions on control outcomes.';
