# Dependency Map

## Dependency Narrative
- Governance and SAS discovery drive scope and sequencing for all delivery streams.
- Data model and ingestion foundations must be in place before conformance, quality, and live operations.
- Dashboards, Genie, and anomaly detection depend on stable Gold products and metadata.
- Cutover and FE rollout depend on transition controls, security/governance, and UAT readiness.

## Mermaid Dependency Graph
```mermaid
flowchart TD
  WS01[WS01_ProgramGovernance] --> WS02[WS02_SASEstateDiscovery]
  WS01 --> WS03[WS03_TargetDataModel]
  WS02 --> WS11[WS11_SASTransitionFactory]
  WS03 --> WS04[WS04_DataIngestionFoundation]
  WS03 --> WS05[WS05_ConformanceAndGoldProducts]
  WS04 --> WS07[WS07_DataQualityAndControls]
  WS04 --> WS08[WS08_LiveDataAndPipelineOps]
  WS05 --> WS09[WS09_DashboardAndGenie]
  WS05 --> WS10[WS10_AnomalyDetectionML]
  WS06[WS06_DictionaryAndMetadataCatalogue] --> WS09
  WS07 --> WS12[WS12_SecurityGovernanceLineage]
  WS08 --> WS13[WS13_UATTrainingOperatingModel]
  WS09 --> WS13
  WS10 --> WS13
  WS11 --> WS14[WS14_FEWorkspaceEnablement]
  WS12 --> WS14
  WS13 --> WS14
```

## Critical Path
1. `WS01 -> WS03 -> WS04 -> WS05 -> WS09 -> WS13 -> WS14`
2. `WS02 -> WS11 -> WS14`
3. `WS04 -> WS07 -> WS12 -> WS14`

## Parallelisable Streams
- `WS06` can run in parallel with late `WS03` and early `WS04`.
- `WS09` and `WS10` can run in parallel once `WS05` and baseline metadata are ready.
- `WS12` can start while `WS11` dual-run is in progress.

## Risk Dependencies to Track
- Source data access and extraction quality from legacy SAS estates.
- Agreement on business definitions for Gold metrics.
- Timely UAT participant availability from Corporate Finance Actuarial.
- Security policy approvals before production rollout.
