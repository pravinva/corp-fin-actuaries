-- Benchmark storage for Genie validation evidence.

CREATE TABLE IF NOT EXISTS corporate_finance.reporting_fin_actuarial.genie_benchmark_catalog (
  benchmark_id STRING,
  benchmark_question STRING,
  expected_sql STRING,
  benchmark_domain STRING,
  priority STRING,
  created_timestamp TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS corporate_finance.reporting_fin_actuarial.genie_benchmark_expected_results (
  benchmark_id STRING,
  result_json STRING,
  expected_result_row_count BIGINT,
  generated_timestamp TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS corporate_finance.reporting_fin_actuarial.genie_benchmark_evaluations (
  benchmark_id STRING,
  evaluator STRING,
  genie_answer_correct BOOLEAN,
  sql_semantically_correct BOOLEAN,
  comments STRING,
  evaluated_timestamp TIMESTAMP
) USING DELTA;
