CREATE TABLE etl.PipelineAudit
(
    AuditID          BIGINT IDENTITY(1,1) NOT NULL,

    PipelineName     VARCHAR(100) NOT NULL,
    PipelineRunID    VARCHAR(100) NULL,

    SourceSystem     VARCHAR(50) NULL,
    DatasetName      VARCHAR(100) NULL,

    StartTime        DATETIME2(3) NOT NULL,
    EndTime          DATETIME2(3) NULL,

    Status           VARCHAR(20) NOT NULL
        CONSTRAINT DF_PipelineAudit_Status
        DEFAULT ('Started'),

    RecordsRead      BIGINT NULL,
    RecordsWritten   BIGINT NULL,

    ErrorMessage     NVARCHAR(4000) NULL,

    TriggerType      VARCHAR(50) NULL,

    CreatedAt        DATETIME2(3) NOT NULL
        CONSTRAINT DF_PipelineAudit_CreatedAt
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_PipelineAudit
        PRIMARY KEY (AuditID),

    CONSTRAINT CK_PipelineAudit_Status
        CHECK (Status IN
        (
            'Started',
            'Running',
            'Succeeded',
            'Failed'
        ))
);

CREATE INDEX IX_PipelineAudit_Pipeline_Status
ON etl.PipelineAudit
(
    PipelineName,
    Status,
    StartTime
);

## auditPipelineValidation
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'etl'
  AND TABLE_NAME = 'PipelineAudit'
ORDER BY ORDINAL_POSITION;
