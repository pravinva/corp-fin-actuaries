-- Corporate Finance Actuarial Demo Worksheet
-- Catalog: corporate_finance
-- Warehouse: 4b9b953939869799

-- ============================================================
-- 1) DATA FOUNDATION
-- ============================================================
SHOW SCHEMAS IN corporate_finance;

SELECT * FROM corporate_finance.landing.policy_extract LIMIT 10;
SELECT * FROM corporate_finance.landing.claims_extract LIMIT 10;
SELECT * FROM corporate_finance.landing.reinsurance_extract LIMIT 10;
SELECT * FROM corporate_finance.landing.finance_extract LIMIT 10;

-- ============================================================
-- 2) GOVERNANCE AND METADATA
-- ============================================================
SHOW GRANTS ON CATALOG corporate_finance;
SHOW GRANTS ON SCHEMA corporate_finance.reporting_fin_actuarial;

DESCRIBE SCHEMA EXTENDED corporate_finance.reporting_fin_actuarial;
DESCRIBE EXTENDED corporate_finance.reporting_fin_actuarial.valuation_movement_bridge;

-- ============================================================
-- 3) DATA QUALITY CONTROLS
-- ============================================================
SELECT *
FROM corporate_finance.reporting_fin_actuarial.dq_claims_summary
ORDER BY dq_run_timestamp DESC
LIMIT 20;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.dq_policy_summary
ORDER BY dq_run_timestamp DESC
LIMIT 20;

SELECT *
FROM corporate_finance.quarantine_fin_actuarial.claims_dq_quarantine
ORDER BY load_timestamp DESC
LIMIT 20;

SELECT *
FROM corporate_finance.quarantine_fin_actuarial.policy_dq_quarantine
ORDER BY load_timestamp DESC
LIMIT 20;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.dq_trend_metrics
ORDER BY run_date DESC, dataset_name
LIMIT 50;

-- ============================================================
-- 4) REPORTING OUTPUTS / DASHBOARD BACKING TABLES
-- ============================================================
SELECT *
FROM corporate_finance.reporting_fin_actuarial.valuation_movement_bridge
ORDER BY as_at_date DESC, portfolio_code;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.gross_to_net_liability_view
ORDER BY as_at_date DESC, portfolio_code;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.close_readiness_indicators
ORDER BY as_at_date DESC;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.portfolio_trend_metrics
ORDER BY as_at_date DESC, portfolio_code;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.valuation_kpi_snapshot
ORDER BY as_at_date DESC, portfolio_code;

-- ============================================================
-- 5) DELTA TIME TRAVEL
-- ============================================================
DESCRIBE HISTORY corporate_finance.reporting_fin_actuarial.valuation_movement_bridge;

SELECT
  portfolio_code,
  as_at_date,
  opening_liability,
  closing_liability,
  movement_amount,
  movement_ratio
FROM corporate_finance.reporting_fin_actuarial.valuation_movement_bridge
ORDER BY as_at_date DESC, portfolio_code;

-- NOTE: adjust VERSION AS OF based on DESCRIBE HISTORY output.
SELECT
  portfolio_code,
  as_at_date,
  opening_liability,
  closing_liability,
  movement_amount,
  movement_ratio
FROM corporate_finance.reporting_fin_actuarial.valuation_movement_bridge VERSION AS OF 1
ORDER BY as_at_date DESC, portfolio_code;

WITH current_snapshot AS (
  SELECT portfolio_code, as_at_date, movement_amount
  FROM corporate_finance.reporting_fin_actuarial.valuation_movement_bridge
),
previous_snapshot AS (
  SELECT portfolio_code, as_at_date, movement_amount
  FROM corporate_finance.reporting_fin_actuarial.valuation_movement_bridge VERSION AS OF 1
)
SELECT
  c.portfolio_code,
  c.as_at_date,
  p.movement_amount AS previous_movement_amount,
  c.movement_amount AS current_movement_amount,
  (c.movement_amount - p.movement_amount) AS delta_movement_amount
FROM current_snapshot c
LEFT JOIN previous_snapshot p
  ON c.portfolio_code = p.portfolio_code
 AND c.as_at_date = p.as_at_date
ORDER BY c.as_at_date DESC, c.portfolio_code;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.valuation_movement_snapshots
ORDER BY snapshot_timestamp DESC
LIMIT 50;

-- ============================================================
-- 6) GENIE EVIDENCE TABLES
-- ============================================================
SELECT *
FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics
ORDER BY as_at_date DESC, portfolio_code
LIMIT 50;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.genie_dq_status
ORDER BY dq_run_timestamp DESC, dataset_name
LIMIT 50;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.genie_benchmark_catalog
ORDER BY benchmark_id;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.genie_benchmark_expected_results
ORDER BY generated_timestamp DESC;

SELECT *
FROM corporate_finance.reporting_fin_actuarial.genie_benchmark_evaluations
ORDER BY evaluated_timestamp DESC;

-- ============================================================
-- 7) GENIE QUESTION SQL EQUIVALENTS
-- (Use these to verify Genie answers manually.)
-- ============================================================

-- Q1: Which portfolios have the largest liability movement in the latest as-at period?
SELECT portfolio_code, as_at_date, movement_amount
FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics
QUALIFY ROW_NUMBER() OVER (ORDER BY as_at_date DESC) >= 1
ORDER BY as_at_date DESC, ABS(movement_amount) DESC
LIMIT 10;

-- Q2: Show gross versus net claim amounts by portfolio for the latest as-at date.
SELECT
  portfolio_code,
  as_at_date,
  SUM(gross_claim_amount) AS gross_claim_amount,
  SUM(net_claim_amount) AS net_claim_amount,
  SUM(reinsurance_impact) AS reinsurance_impact
FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics
GROUP BY portfolio_code, as_at_date
ORDER BY as_at_date DESC, portfolio_code;

-- Q3: Which dataset has the highest failed data quality checks in the latest run?
SELECT
  dataset_name,
  dq_run_timestamp,
  (claim_amount_fail_count + report_after_loss_fail_count + claim_id_fail_count + policy_id_fail_count + inception_expiry_fail_count) AS total_failures
FROM corporate_finance.reporting_fin_actuarial.genie_dq_status
ORDER BY dq_run_timestamp DESC, total_failures DESC
LIMIT 5;

-- Q4: Is close readiness flagged as true for the latest as-at date?
SELECT as_at_date, close_readiness_flag
FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics
ORDER BY as_at_date DESC
LIMIT 10;

-- Q5: What is the movement ratio trend by portfolio over the last two as-at periods?
WITH ranked AS (
  SELECT
    portfolio_code,
    as_at_date,
    movement_ratio,
    ROW_NUMBER() OVER (PARTITION BY portfolio_code ORDER BY as_at_date DESC) AS rn
  FROM corporate_finance.reporting_fin_actuarial.genie_finance_actuarial_metrics
)
SELECT portfolio_code, as_at_date, movement_ratio
FROM ranked
WHERE rn <= 2
ORDER BY portfolio_code, as_at_date DESC;
