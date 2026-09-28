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
