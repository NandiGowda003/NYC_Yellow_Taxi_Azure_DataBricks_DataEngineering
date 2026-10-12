UPDATE etl.IngestionControl
SET
    Status = 'Pending',
    StartedAt = NULL,
    CompletedAt = NULL,
    [RowCount] = NULL,
    ErrorMessage = NULL,
    PipelineRunID = NULL,
    UpdatedAt = SYSUTCDATETIME()
WHERE [Year] = 2026
  AND [Month] BETWEEN 1 AND 8
  AND SourceSystem IN ('NYC_TLC', 'NYC TLC')
  AND DatasetName = 'Yellow Taxi';
