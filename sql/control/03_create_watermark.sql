CREATE TABLE etl.Watermark
(
    WatermarkID        INT IDENTITY(1,1) NOT NULL,

    PipelineName       VARCHAR(100) NOT NULL,
    DatasetName        VARCHAR(100) NOT NULL,

    WatermarkColumn    VARCHAR(100) NOT NULL,
    LastProcessedValue VARCHAR(100) NULL,

    UpdatedAt          DATETIME2(3) NOT NULL
        CONSTRAINT DF_Watermark_UpdatedAt
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_Watermark
        PRIMARY KEY (WatermarkID),

    CONSTRAINT UQ_Watermark_PipelineDataset
        UNIQUE (PipelineName, DatasetName)
);

## CreateIndex
CREATE INDEX IX_Watermark_PipelineDataset
ON etl.Watermark
(
    PipelineName,
    DatasetName
);

## WatermarkValidation
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'etl'
  AND TABLE_NAME = 'Watermark'
ORDER BY ORDINAL_POSITION;
