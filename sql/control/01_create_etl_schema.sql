IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'etl'
)
BEGIN
    EXEC('CREATE SCHEMA etl');
END;
GO


SELECT
    name AS SchemaName
FROM sys.schemas
WHERE name = 'etl';
