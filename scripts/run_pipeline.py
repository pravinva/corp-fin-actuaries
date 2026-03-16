"""Local entry point for running the finance actuarial pipeline."""

from pyspark.sql import SparkSession

from src.pipelines.finance_actuarial_pipeline import run_pipeline


def main() -> None:
    spark = SparkSession.builder.appName("corp-fin-actuarial-pipeline").getOrCreate()
    run_pipeline(spark)


if __name__ == "__main__":
    main()
