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
