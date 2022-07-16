CREATE FUNCTION tSQLt.Private_ResolveFakeTableNamesForBackwardCompatibility (@TableName NVARCHAR(MAX), @SchemaName NVARCHAR(MAX))
RETURNS @FakeTableNamesForBackwardCompatibility TABLE
(
    CleanSchemaName NVARCHAR(MAX) NULL,
    CleanTableName NVARCHAR(MAX) NULL
) AS
BEGIN
    INSERT INTO @FakeTableNamesForBackwardCompatibility
    SELECT
        QUOTENAME(OBJECT_SCHEMA_NAME(ObjectId)),
        QUOTENAME(OBJECT_NAME(ObjectId))
    FROM
    (
        SELECT CASE
            WHEN @SchemaName IS NULL THEN OBJECT_ID(@TableName)
            ELSE ISNULL(OBJECT_ID(CONCAT(@SchemaName, '.', @TableName)), OBJECT_ID(CONCAT(@TableName, '.', @SchemaName)))
        END ObjectId
    ) A

    RETURN;
END;
GO