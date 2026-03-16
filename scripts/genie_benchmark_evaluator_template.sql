-- Manual evaluation template for Genie benchmark runs.
-- Replace placeholders per benchmark/evaluator.

INSERT INTO corporate_finance.reporting_fin_actuarial.genie_benchmark_evaluations
VALUES
  (
    'B001',
    current_user(),
    true,
    true,
    'Answer and SQL aligned with expected movement output.',
    current_timestamp()
  );
