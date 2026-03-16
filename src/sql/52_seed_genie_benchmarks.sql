-- Seed Genie benchmark catalog and expected results directly in SQL.

DELETE FROM corporate_finance.reporting_fin_actuarial.genie_benchmark_catalog;

INSERT INTO corporate_finance.reporting_fin_actuarial.genie_benchmark_catalog
VALUES
  (
    'B001',
    'Which portfolios have the largest liability movement in the latest as-at period?',
    'SELECT portfolio_code, as_at_date, movement_amount FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics ORDER BY as_at_date DESC, ABS(movement_amount) DESC LIMIT 10',
    'valuation_movement',
    'high',
    current_timestamp()
  ),
  (
    'B002',
    'Show gross versus net claim amounts by portfolio for the latest as-at date.',
    'SELECT portfolio_code, as_at_date, SUM(gross_claim_amount) AS gross_claim_amount, SUM(net_claim_amount) AS net_claim_amount, SUM(reinsurance_impact) AS reinsurance_impact FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics GROUP BY portfolio_code, as_at_date ORDER BY as_at_date DESC, portfolio_code',
    'gross_net_liability',
    'high',
    current_timestamp()
  ),
  (
    'B003',
    'Which dataset has the highest failed data quality checks in the latest run?',
    'SELECT dataset_name, dq_run_timestamp, (claim_amount_fail_count + report_after_loss_fail_count + claim_id_fail_count + policy_id_fail_count + inception_expiry_fail_count) AS total_failures FROM corporate_finance.reporting_fin_actuarial.genie_dq_status ORDER BY dq_run_timestamp DESC, total_failures DESC LIMIT 5',
    'data_quality',
    'high',
    current_timestamp()
  ),
  (
    'B004',
    'Is close readiness flagged as true for the latest as-at date?',
    'SELECT as_at_date, close_readiness_flag FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics ORDER BY as_at_date DESC LIMIT 10',
    'close_readiness',
    'medium',
    current_timestamp()
  ),
  (
    'B005',
    'What is the movement ratio trend by portfolio over the last two as-at periods?',
    'WITH ranked AS (SELECT portfolio_code, as_at_date, movement_ratio, ROW_NUMBER() OVER (PARTITION BY portfolio_code ORDER BY as_at_date DESC) AS rn FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics) SELECT portfolio_code, as_at_date, movement_ratio FROM ranked WHERE rn <= 2 ORDER BY portfolio_code, as_at_date DESC',
    'trend_analysis',
    'medium',
    current_timestamp()
  );

DELETE FROM corporate_finance.reporting_fin_actuarial.genie_benchmark_expected_results;

INSERT INTO corporate_finance.reporting_fin_actuarial.genie_benchmark_expected_results
SELECT
  'B001' AS benchmark_id,
  to_json(
    collect_list(
      named_struct(
        'portfolio_code', portfolio_code,
        'as_at_date', CAST(as_at_date AS STRING),
        'movement_amount', movement_amount
      )
    )
  ) AS result_json,
  COUNT(*) AS expected_result_row_count,
  current_timestamp() AS generated_timestamp
FROM (
  SELECT portfolio_code, as_at_date, movement_amount
  FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics
  ORDER BY as_at_date DESC, ABS(movement_amount) DESC
  LIMIT 10
) t1
UNION ALL
SELECT
  'B002' AS benchmark_id,
  to_json(
    collect_list(
      named_struct(
        'portfolio_code', portfolio_code,
        'as_at_date', CAST(as_at_date AS STRING),
        'gross_claim_amount', gross_claim_amount,
        'net_claim_amount', net_claim_amount,
        'reinsurance_impact', reinsurance_impact
      )
    )
  ) AS result_json,
  COUNT(*) AS expected_result_row_count,
  current_timestamp() AS generated_timestamp
FROM (
  SELECT
    portfolio_code,
    as_at_date,
    SUM(gross_claim_amount) AS gross_claim_amount,
    SUM(net_claim_amount) AS net_claim_amount,
    SUM(reinsurance_impact) AS reinsurance_impact
  FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics
  GROUP BY portfolio_code, as_at_date
  ORDER BY as_at_date DESC, portfolio_code
) t2
UNION ALL
SELECT
  'B003' AS benchmark_id,
  to_json(
    collect_list(
      named_struct(
        'dataset_name', dataset_name,
        'dq_run_timestamp', CAST(dq_run_timestamp AS STRING),
        'total_failures',
        (claim_amount_fail_count + report_after_loss_fail_count + claim_id_fail_count + policy_id_fail_count + inception_expiry_fail_count)
      )
    )
  ) AS result_json,
  COUNT(*) AS expected_result_row_count,
  current_timestamp() AS generated_timestamp
FROM (
  SELECT
    dataset_name,
    dq_run_timestamp,
    claim_amount_fail_count,
    report_after_loss_fail_count,
    claim_id_fail_count,
    policy_id_fail_count,
    inception_expiry_fail_count
  FROM corporate_finance.reporting_fin_actuarial.genie_dq_status
  ORDER BY dq_run_timestamp DESC
  LIMIT 5
) t3;
