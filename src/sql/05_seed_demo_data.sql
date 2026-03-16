-- Seed deterministic demo data directly in the Field Engineering workspace.
-- Target catalog: corporate_finance

CREATE OR REPLACE TABLE corporate_finance.landing.policy_extract AS
WITH base AS (
  SELECT id FROM range(1, 41)
),
dates AS (
  SELECT CAST('2026-02-28' AS DATE) AS as_at_date
  UNION ALL
  SELECT CAST('2026-03-31' AS DATE) AS as_at_date
)
SELECT
  concat('POL', lpad(CAST(id AS STRING), 4, '0')) AS policy_id,
  concat('CUST', lpad(CAST(((id % 15) + 1) AS STRING), 3, '0')) AS customer_id,
  element_at(array('motor', 'home', 'ctp', 'commercial'), CAST(((id - 1) % 4) + 1 AS INT)) AS portfolio_code,
  date_add(as_at_date, CAST(-(365 + id) AS INT)) AS inception_date,
  date_add(date_add(as_at_date, CAST(-(365 + id) AS INT)), CAST(365 AS INT)) AS expiry_date,
  as_at_date
FROM base
CROSS JOIN dates;

CREATE OR REPLACE TABLE corporate_finance.landing.claims_extract AS
WITH base AS (
  SELECT id FROM range(1, 61)
),
dates AS (
  SELECT CAST('2026-02-28' AS DATE) AS as_at_date, 1.00 AS multiplier
  UNION ALL
  SELECT CAST('2026-03-31' AS DATE) AS as_at_date, 1.06 AS multiplier
)
SELECT
  concat('CLM', lpad(CAST(id AS STRING), 5, '0')) AS claim_id,
  concat('POL', lpad(CAST(((id % 40) + 1) AS STRING), 4, '0')) AS policy_id,
  element_at(array('motor', 'home', 'ctp', 'commercial'), CAST(((id - 1) % 4) + 1 AS INT)) AS portfolio_code,
  date_add(as_at_date, CAST(-((id % 180) + 1) AS INT)) AS loss_date,
  CASE
    WHEN id = 11 THEN date_add(as_at_date, CAST(-((id % 180) + 3) AS INT)) -- intentional DQ fail
    ELSE date_add(date_add(as_at_date, CAST(-((id % 180) + 1) AS INT)), CAST((id % 7) AS INT))
  END AS report_date,
  CASE
    WHEN id = 7 THEN -25.0 -- intentional DQ fail
    ELSE ROUND((800 + (id * 35)) * multiplier, 2)
  END AS claim_amount,
  as_at_date
FROM base
CROSS JOIN dates;

CREATE OR REPLACE TABLE corporate_finance.landing.reinsurance_extract AS
WITH base AS (
  SELECT id FROM range(1, 61)
),
dates AS (
  SELECT CAST('2026-02-28' AS DATE) AS as_at_date, 0.20 AS recovery_ratio
  UNION ALL
  SELECT CAST('2026-03-31' AS DATE) AS as_at_date, 0.18 AS recovery_ratio
)
SELECT
  concat('TRT', lpad(CAST(id AS STRING), 5, '0')) AS treaty_id,
  concat('CLM', lpad(CAST(id AS STRING), 5, '0')) AS claim_id,
  ROUND((800 + (id * 35)) * recovery_ratio, 2) AS reinsurance_recovery_amount,
  as_at_date
FROM base
CROSS JOIN dates;

CREATE OR REPLACE TABLE corporate_finance.landing.finance_extract AS
WITH base AS (
  SELECT stack(
    4,
    'motor', 1110000.0, 57500.0,
    'home', 1220000.0, 65000.0,
    'ctp', 1330000.0, 72500.0,
    'commercial', 1440000.0, 80000.0
  ) AS (portfolio_code, opening_liability, base_movement)
),
dates AS (
  SELECT CAST('2026-02-28' AS DATE) AS as_at_date, 1.00 AS bias
  UNION ALL
  SELECT CAST('2026-03-31' AS DATE) AS as_at_date, 1.08 AS bias
)
SELECT
  concat('JRNL_', portfolio_code, '_', CAST(as_at_date AS STRING)) AS journal_id,
  portfolio_code,
  opening_liability,
  opening_liability + (base_movement * bias) AS closing_liability,
  ROUND(base_movement * bias, 2) AS movement_amount,
  as_at_date
FROM base
CROSS JOIN dates;

-- Build conformed and quarantine layers with explicit DQ flags.
CREATE OR REPLACE TABLE corporate_finance.conformed_fin_actuarial.claims_silver AS
SELECT
  c.*,
  r.reinsurance_recovery_amount,
  c.claim_amount - COALESCE(r.reinsurance_recovery_amount, 0) AS net_claim_amount,
  current_timestamp() AS load_timestamp
FROM corporate_finance.landing.claims_extract c
LEFT JOIN corporate_finance.landing.reinsurance_extract r
  ON c.claim_id = r.claim_id AND c.as_at_date = r.as_at_date
WHERE c.claim_amount >= 0
  AND c.report_date >= c.loss_date
  AND c.claim_id IS NOT NULL;

CREATE OR REPLACE TABLE corporate_finance.quarantine_fin_actuarial.claims_dq_quarantine AS
SELECT
  c.*,
  current_timestamp() AS load_timestamp
FROM corporate_finance.landing.claims_extract c
WHERE NOT (
  c.claim_amount >= 0
  AND c.report_date >= c.loss_date
  AND c.claim_id IS NOT NULL
);

CREATE OR REPLACE TABLE corporate_finance.conformed_fin_actuarial.policy_silver AS
SELECT
  p.*,
  current_timestamp() AS load_timestamp
FROM corporate_finance.landing.policy_extract p
WHERE p.policy_id IS NOT NULL
  AND p.inception_date <= p.expiry_date;

CREATE OR REPLACE TABLE corporate_finance.quarantine_fin_actuarial.policy_dq_quarantine AS
SELECT
  p.*,
  current_timestamp() AS load_timestamp
FROM corporate_finance.landing.policy_extract p
WHERE NOT (p.policy_id IS NOT NULL AND p.inception_date <= p.expiry_date);

CREATE OR REPLACE TABLE corporate_finance.reporting_fin_actuarial.dq_claims_summary AS
SELECT
  'claims' AS dataset_name,
  COUNT(*) AS total_record_count,
  SUM(CASE WHEN claim_amount >= 0 THEN 1 ELSE 0 END) AS dq_claim_amount_non_negative_pass_count,
  SUM(CASE WHEN claim_amount < 0 THEN 1 ELSE 0 END) AS dq_claim_amount_non_negative_fail_count,
  SUM(CASE WHEN report_date >= loss_date THEN 1 ELSE 0 END) AS dq_report_after_loss_pass_count,
  SUM(CASE WHEN report_date < loss_date THEN 1 ELSE 0 END) AS dq_report_after_loss_fail_count,
  SUM(CASE WHEN claim_id IS NOT NULL THEN 1 ELSE 0 END) AS dq_claim_id_present_pass_count,
  SUM(CASE WHEN claim_id IS NULL THEN 1 ELSE 0 END) AS dq_claim_id_present_fail_count,
  current_timestamp() AS dq_run_timestamp
FROM corporate_finance.landing.claims_extract;

CREATE OR REPLACE TABLE corporate_finance.reporting_fin_actuarial.dq_policy_summary AS
SELECT
  'policy' AS dataset_name,
  COUNT(*) AS total_record_count,
  SUM(CASE WHEN policy_id IS NOT NULL THEN 1 ELSE 0 END) AS dq_policy_id_present_pass_count,
  SUM(CASE WHEN policy_id IS NULL THEN 1 ELSE 0 END) AS dq_policy_id_present_fail_count,
  SUM(CASE WHEN inception_date <= expiry_date THEN 1 ELSE 0 END) AS dq_inception_before_expiry_pass_count,
  SUM(CASE WHEN inception_date > expiry_date THEN 1 ELSE 0 END) AS dq_inception_before_expiry_fail_count,
  current_timestamp() AS dq_run_timestamp
FROM corporate_finance.landing.policy_extract;

-- Create two table versions for time travel demonstration.
CREATE OR REPLACE TABLE corporate_finance.reporting_fin_actuarial.valuation_movement_bridge AS
SELECT
  portfolio_code,
  as_at_date,
  SUM(opening_liability) AS opening_liability,
  SUM(closing_liability) AS closing_liability,
  SUM(movement_amount) AS movement_amount,
  SUM(movement_amount) / CASE WHEN SUM(opening_liability) = 0 THEN 1 ELSE SUM(opening_liability) END AS movement_ratio
FROM corporate_finance.landing.finance_extract
WHERE as_at_date = CAST('2026-02-28' AS DATE)
GROUP BY portfolio_code, as_at_date;

CREATE OR REPLACE TABLE corporate_finance.reporting_fin_actuarial.valuation_movement_bridge AS
SELECT
  portfolio_code,
  as_at_date,
  SUM(opening_liability) AS opening_liability,
  SUM(closing_liability) AS closing_liability,
  SUM(movement_amount) AS movement_amount,
  SUM(movement_amount) / CASE WHEN SUM(opening_liability) = 0 THEN 1 ELSE SUM(opening_liability) END AS movement_ratio
FROM corporate_finance.landing.finance_extract
GROUP BY portfolio_code, as_at_date;

CREATE OR REPLACE TABLE corporate_finance.reporting_fin_actuarial.gross_to_net_liability_view AS
SELECT
  portfolio_code,
  as_at_date,
  SUM(claim_amount) AS gross_claim_amount,
  SUM(net_claim_amount) AS net_claim_amount,
  SUM(claim_amount) - SUM(net_claim_amount) AS reinsurance_impact
FROM corporate_finance.conformed_fin_actuarial.claims_silver
GROUP BY portfolio_code, as_at_date;

CREATE OR REPLACE TABLE corporate_finance.reporting_fin_actuarial.close_readiness_indicators AS
WITH p AS (
  SELECT as_at_date, COUNT(DISTINCT policy_id) AS policy_record_count
  FROM corporate_finance.conformed_fin_actuarial.policy_silver
  GROUP BY as_at_date
),
c AS (
  SELECT as_at_date, COUNT(DISTINCT claim_id) AS claim_record_count
  FROM corporate_finance.conformed_fin_actuarial.claims_silver
  GROUP BY as_at_date
)
SELECT
  COALESCE(p.as_at_date, c.as_at_date) AS as_at_date,
  COALESCE(policy_record_count, 0) AS policy_record_count,
  COALESCE(claim_record_count, 0) AS claim_record_count,
  (COALESCE(policy_record_count, 0) > 0 AND COALESCE(claim_record_count, 0) > 0) AS close_readiness_flag
FROM p
FULL OUTER JOIN c
  ON p.as_at_date = c.as_at_date;

CREATE OR REPLACE TABLE corporate_finance.reporting_fin_actuarial.valuation_movement_snapshots AS
SELECT
  portfolio_code,
  as_at_date,
  opening_liability,
  closing_liability,
  movement_amount,
  movement_ratio,
  current_timestamp() AS snapshot_timestamp
FROM corporate_finance.reporting_fin_actuarial.valuation_movement_bridge;
