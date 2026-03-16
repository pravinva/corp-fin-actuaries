-- Data quality monitoring queries for Corporate Finance Actuarial demo.

-- Latest quality run for claims and policy.
SELECT *
FROM corporate_finance.reporting_fin_actuarial.dq_claims_summary
ORDER BY dq_run_timestamp DESC
LIMIT 20;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.dq_policy_summary
ORDER BY dq_run_timestamp DESC
LIMIT 20;

-- Quarantine volumes over time.
SELECT
  date(load_timestamp) AS load_date,
  COUNT(*) AS quarantine_record_count
FROM corporate_finance.quarantine_fin_actuarial.claims_dq_quarantine
GROUP BY date(load_timestamp)
ORDER BY load_date DESC;

-- Combined DQ trend for dashboarding.
CREATE OR REPLACE VIEW corporate_finance.reporting_fin_actuarial.dq_trend_metrics AS
SELECT
  dataset_name,
  date(dq_run_timestamp) AS run_date,
  total_record_count,
  claim_amount_fail_count,
  report_after_loss_fail_count,
  claim_id_fail_count,
  policy_id_fail_count,
  inception_expiry_fail_count
FROM (
  SELECT
    dataset_name,
    dq_run_timestamp,
    total_record_count,
    dq_claim_amount_non_negative_fail_count AS claim_amount_fail_count,
    dq_report_after_loss_fail_count AS report_after_loss_fail_count,
    dq_claim_id_present_fail_count AS claim_id_fail_count,
    CAST(0 AS BIGINT) AS policy_id_fail_count,
    CAST(0 AS BIGINT) AS inception_expiry_fail_count
  FROM corporate_finance.reporting_fin_actuarial.dq_claims_summary
  UNION ALL
  SELECT
    dataset_name,
    dq_run_timestamp,
    total_record_count,
    CAST(0 AS BIGINT) AS claim_amount_fail_count,
    CAST(0 AS BIGINT) AS report_after_loss_fail_count,
    CAST(0 AS BIGINT) AS claim_id_fail_count,
    dq_policy_id_present_fail_count AS policy_id_fail_count,
    dq_inception_before_expiry_fail_count AS inception_expiry_fail_count
  FROM corporate_finance.reporting_fin_actuarial.dq_policy_summary
);
