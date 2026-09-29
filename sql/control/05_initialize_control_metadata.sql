INSERT INTO etl.IngestionControl
(
    SourceSystem,
    DatasetName,
    [Year],
    [Month],
    FileName,
    SourceURL,
    Status
)
VALUES
(
    'NYC_TLC',
    'Yellow Taxi',
    2026,
    1,
    'yellow_tripdata_2026-01.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-01.parquet',
    'Pending'
),
(
    'NYC_TLC',
    'Yellow Taxi',
    2026,
    2,
    'yellow_tripdata_2026-02.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-02.parquet',
    'Pending'
),
(
    'NYC_TLC',
    'Yellow Taxi',
    2026,
    3,
    'yellow_tripdata_2026-03.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-03.parquet',
    'Pending'
),
(
    'NYC_TLC',
    'Yellow Taxi',
    2026,
    4,
    'yellow_tripdata_2026-04.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-04.parquet',
    'Pending'
),
(
    'NYC_TLC',
    'Yellow Taxi',
    2026,
    5,
    'yellow_tripdata_2026-05.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-05.parquet',
    'Pending'
),
(
    'NYC_TLC',
    'Yellow Taxi',
    2026,
    6,
    'yellow_tripdata_2026-06.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-06.parquet',
    'Pending'
),
(
    'NYC_TLC',
    'Yellow Taxi',
    2026,
    7,
    'yellow_tripdata_2026-07.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-07.parquet',
    'Pending'
);

INSERT INTO etl.Watermark
(
    PipelineName,
    DatasetName,
    WatermarkColumn,
    LastProcessedValue
)
VALUES
(
    'PL_NYC_Taxi_Incremental',
    'Yellow Taxi',
    'SourcePeriod',
    NULL
);
