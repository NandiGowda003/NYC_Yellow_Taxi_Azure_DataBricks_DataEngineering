CREATE OR ALTER PROCEDURE etl.usp_MarkIngestionProcessing
    @ControlID BIGINT,
    @PipelineRunID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE etl.IngestionControl
    SET
        Status = 'Processing',
        StartedAt = SYSUTCDATETIME(),
        PipelineRunID = @PipelineRunID,
        UpdatedAt = SYSUTCDATETIME(),
        ErrorMessage = NULL
    WHERE ControlID = @ControlID
      AND Status IN ('Pending', 'Failed');
END;


CREATE OR ALTER PROCEDURE etl.usp_UpdateWatermark
    @PipelineName VARCHAR(100),
    @DatasetName VARCHAR(100),
    @LastProcessedValue VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE etl.Watermark
    SET
        LastProcessedValue = @LastProcessedValue,
        UpdatedAt = SYSUTCDATETIME()
    WHERE PipelineName = @PipelineName
      AND DatasetName = @DatasetName;
END;
