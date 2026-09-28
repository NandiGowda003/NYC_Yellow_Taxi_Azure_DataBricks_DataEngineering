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

CREATE OR ALTER PROCEDURE etl.usp_MarkIngestionSuccess
    @ControlID BIGINT,
    @RowCount BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE etl.IngestionControl
    SET
        Status = 'Success',
        CompletedAt = SYSUTCDATETIME(),
        [RowCount] = @RowCount,
        UpdatedAt = SYSUTCDATETIME(),
        ErrorMessage = NULL
    WHERE ControlID = @ControlID
      AND Status = 'Processing';
END;


CREATE OR ALTER PROCEDURE etl.usp_MarkIngestionFailed
    @ControlID BIGINT,
    @ErrorMessage NVARCHAR(4000)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE etl.IngestionControl
    SET
        Status = 'Failed',
        ErrorMessage = @ErrorMessage,
        UpdatedAt = SYSUTCDATETIME()
    WHERE ControlID = @ControlID
      AND Status = 'Processing';
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

CREATE OR ALTER PROCEDURE etl.usp_StartPipelineAudit
    @PipelineName VARCHAR(100),
    @PipelineRunID VARCHAR(100),
    @SourceSystem VARCHAR(50),
    @DatasetName VARCHAR(100),
    @TriggerType VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO etl.PipelineAudit
    (
        PipelineName,
        PipelineRunID,
        SourceSystem,
        DatasetName,
        StartTime,
        Status,
        TriggerType
    )
    VALUES
    (
        @PipelineName,
        @PipelineRunID,
        @SourceSystem,
        @DatasetName,
        SYSUTCDATETIME(),
        'Started',
        @TriggerType
    );
END;

CREATE OR ALTER PROCEDURE etl.usp_CompletePipelineAudit
    @PipelineRunID VARCHAR(100),
    @Status VARCHAR(20),
    @RecordsRead BIGINT = NULL,
    @RecordsWritten BIGINT = NULL,
    @ErrorMessage NVARCHAR(4000) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE etl.PipelineAudit
    SET
        EndTime = SYSUTCDATETIME(),
        Status = @Status,
        RecordsRead = @RecordsRead,
        RecordsWritten = @RecordsWritten,
        ErrorMessage = @ErrorMessage
    WHERE PipelineRunID = @PipelineRunID
      AND Status IN ('Started', 'Running');
END;
