CREATE TABLE etl.IngestionControl
(
    ControlID       BIGINT IDENTITY(1,1) NOT NULL,
    
    SourceSystem    VARCHAR(50)  NOT NULL,
    DatasetName     VARCHAR(100) NOT NULL,
    
    [Year]          SMALLINT     NOT NULL,
    [Month]         TINYINT      NOT NULL,
    
    FileName        VARCHAR(255) NOT NULL,
    SourceURL       VARCHAR(1000) NOT NULL,
    
    Status          VARCHAR(20)  NOT NULL
        CONSTRAINT DF_IngestionControl_Status
        DEFAULT ('Pending'),
    
    StartedAt       DATETIME2(3) NULL,
    CompletedAt     DATETIME2(3) NULL,
    
    [RowCount]       BIGINT NULL,
    
    ErrorMessage    NVARCHAR(4000) NULL,
    
    PipelineRunID   VARCHAR(100) NULL,
    
    CreatedAt       DATETIME2(3) NOT NULL
        CONSTRAINT DF_IngestionControl_CreatedAt
        DEFAULT (SYSUTCDATETIME()),
    
    UpdatedAt       DATETIME2(3) NOT NULL
        CONSTRAINT DF_IngestionControl_UpdatedAt
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_IngestionControl
        PRIMARY KEY (ControlID),

    CONSTRAINT UQ_IngestionControl_SourcePeriod
        UNIQUE (SourceSystem, DatasetName, [Year], [Month]),

    CONSTRAINT CK_IngestionControl_Month
        CHECK ([Month] BETWEEN 1 AND 12),

    CONSTRAINT CK_IngestionControl_Status
        CHECK (Status IN
        (
            'Pending',
            'Processing',
            'Success',
            'Failed'
        ))
);

## CreateIndexTable
CREATE INDEX IX_IngestionControl_Status_Period
ON etl.IngestionControl
(
    Status,
    [Year],
    [Month]
);

## IndexSchemaValidation
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'etl'
  AND TABLE_NAME = 'IngestionControl'
ORDER BY ORDINAL_POSITION;
