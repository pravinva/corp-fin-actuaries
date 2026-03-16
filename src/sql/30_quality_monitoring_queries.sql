-- Data quality monitoring queries for Corporate Finance Actuarial demo.

-- Latest quality run for claims and policy.
SELECT *
FROM corp_fin_actuarial.reporting_fin_actuarial.dq_claims_summary
ORDER BY dq_run_timestamp DESC
LIMIT 20;

SELECT *
FROM corp_fin_actuarial.reporting_fin_actuarial.dq_policy_summary
ORDER BY dq_run_timestamp DESC
LIMIT 20;

-- Quarantine volumes over time.
SELECT
  date(load_timestamp) AS load_date,
  COUNT(*) AS quarantine_record_count
FROM corp_fin_actuarial.quarantine_fin_actuarial.claims_dq_quarantine
GROUP BY date(load_timestamp)
ORDER BY load_date DESC;

-- Combined DQ trend for dashboarding.
CREATE OR REPLACE VIEW corp_fin_actuarial.reporting_fin_actuarial.dq_trend_metrics AS
SELECT
  dataset_name,
  date(dq_run_timestamp) AS run_date,
  total_record_count,
  -- Claims rule examples
  COALESCE(dq_claim_amount_non_negative_fail_count, 0) AS claim_amount_fail_count,
  COALESCE(dq_report_after_loss_fail_count, 0) AS report_after_loss_fail_count,
  COALESCE(dq_claim_id_present_fail_count, 0) AS claim_id_fail_count,
  -- Policy rule examples
  COALESCE(dq_policy_id_present_fail_count, 0) AS policy_id_fail_count,
  COALESCE(dq_inception_before_expiry_fail_count, 0) AS inception_expiry_fail_count
FROM (
  SELECT * FROM corp_fin_actuarial.reporting_fin_actuarial.dq_claims_summary
  UNION ALL
  SELECT * FROM corp_fin_actuarial.reporting_fin_actuarial.dq_policy_summary
);
