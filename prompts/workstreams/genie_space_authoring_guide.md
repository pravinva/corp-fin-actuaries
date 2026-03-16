# Genie Space Authoring Guide (Corporate Finance Actuarial)

Use this guide to configure a Genie space that is aligned to Corporate Finance Actuarial consumers.

## Data Assets to Add
- `corp_fin_actuarial.reporting_fin_actuarial.genie_finance_actuarial_metrics`
- `corp_fin_actuarial.reporting_fin_actuarial.genie_dq_status`
- `corp_fin_actuarial.reporting_fin_actuarial.portfolio_trend_metrics`
- `corp_fin_actuarial.reporting_fin_actuarial.valuation_kpi_snapshot`

## Required General Instructions (Paste into Genie)
1. This space is for Corporate Finance Actuarial outcomes, not pricing analytics.
2. Prefer as-at date based trend outputs and portfolio-level summaries.
3. Use movement amount and movement ratio for valuation movement questions.
4. For gross vs net questions, include reinsurance impact in the response.
5. When answering data quality questions, query `genie_dq_status`.
6. If a user asks for operational claims handling details, clarify this space is for corporate finance actuarial monitoring.

## Starter SQL Examples (Trusted Assets)
### Example 1: Top movement portfolios
```sql
SELECT
  as_at_date,
  portfolio_code,
  movement_amount
FROM corp_fin_actuarial.reporting_fin_actuarial.genie_finance_actuarial_metrics
ORDER BY as_at_date DESC, ABS(movement_amount) DESC
LIMIT 20;
```

### Example 2: Gross vs net liability trend
```sql
SELECT
  as_at_date,
  portfolio_code,
  SUM(gross_claim_amount) AS gross_claim_amount,
  SUM(net_claim_amount) AS net_claim_amount,
  SUM(reinsurance_impact) AS reinsurance_impact
FROM corp_fin_actuarial.reporting_fin_actuarial.genie_finance_actuarial_metrics
GROUP BY as_at_date, portfolio_code
ORDER BY as_at_date DESC, portfolio_code;
```

### Example 3: Latest data quality status
```sql
SELECT *
FROM corp_fin_actuarial.reporting_fin_actuarial.genie_dq_status
ORDER BY dq_run_timestamp DESC, dataset_name
LIMIT 20;
```

## Benchmark Questions for UAT
1. Which portfolios have the largest liability movement this period?
2. Show gross versus net claim amounts for the latest as-at date.
3. Which dataset had the highest failed data quality checks in the latest run?
4. Is the close readiness flag true for the latest valuation date?
5. What is the trend in movement ratio for each portfolio over the last 3 as-at dates?

## Sign-off Criteria
- 90%+ benchmark questions produce correct SQL and correct answer.
- No pricing-oriented interpretation for corporate-finance-only prompts.
- Data quality questions consistently route to `genie_dq_status`.
