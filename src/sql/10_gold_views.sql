CREATE OR REPLACE VIEW corporate_finance.reporting_fin_actuarial.portfolio_trend_metrics AS
SELECT
  portfolio_code,
  as_at_date,
  SUM(gross_claim_amount) AS gross_claim_amount,
  SUM(net_claim_amount) AS net_claim_amount,
  SUM(reinsurance_impact) AS reinsurance_impact
FROM corporate_finance.reporting_fin_actuarial.gross_to_net_liability_view
GROUP BY portfolio_code, as_at_date;

CREATE OR REPLACE VIEW corporate_finance.reporting_fin_actuarial.valuation_kpi_snapshot AS
SELECT
  vmb.portfolio_code,
  vmb.as_at_date,
  vmb.opening_liability,
  vmb.closing_liability,
  vmb.movement_amount,
  vmb.movement_ratio,
  ptr.gross_claim_amount,
  ptr.net_claim_amount
FROM corporate_finance.reporting_fin_actuarial.valuation_movement_bridge AS vmb
LEFT JOIN corporate_finance.reporting_fin_actuarial.portfolio_trend_metrics AS ptr
  ON vmb.portfolio_code = ptr.portfolio_code
 AND vmb.as_at_date = ptr.as_at_date;
