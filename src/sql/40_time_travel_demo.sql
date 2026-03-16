-- Delta time travel demonstration for Corporate Finance Actuarial.
-- Run pipeline multiple times (with changed source data) to create versions.

-- 1) Inspect table history.
DESCRIBE HISTORY corp_fin_actuarial.reporting_fin_actuarial.valuation_movement_bridge;

-- 2) Query current snapshot.
SELECT
  portfolio_code,
  as_at_date,
  opening_liability,
  closing_liability,
  movement_amount,
  movement_ratio
FROM corp_fin_actuarial.reporting_fin_actuarial.valuation_movement_bridge
ORDER BY as_at_date DESC, portfolio_code
LIMIT 100;

-- 3) Query previous version (example uses VERSION AS OF 1; adjust based on history output).
SELECT
  portfolio_code,
  as_at_date,
  opening_liability,
  closing_liability,
  movement_amount,
  movement_ratio
FROM corp_fin_actuarial.reporting_fin_actuarial.valuation_movement_bridge VERSION AS OF 1
ORDER BY as_at_date DESC, portfolio_code
LIMIT 100;

-- 4) Compare current vs previous values.
WITH current_snapshot AS (
  SELECT portfolio_code, as_at_date, movement_amount
  FROM corp_fin_actuarial.reporting_fin_actuarial.valuation_movement_bridge
),
previous_snapshot AS (
  SELECT portfolio_code, as_at_date, movement_amount
  FROM corp_fin_actuarial.reporting_fin_actuarial.valuation_movement_bridge VERSION AS OF 1
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
