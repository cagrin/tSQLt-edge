CREATE FUNCTION tSQLt.Private_GetTypeName (@TypeId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT
        CASE
        WHEN SCHEMA_NAME(schema_id) <> 'sys' THEN CONCAT(QUOTENAME(SCHEMA_NAME(schema_id)), '.', QUOTENAME(TYPE_NAME(@TypeId)))
        ELSE TYPE_NAME(@TypeId) END
        FROM tSQLt.System_Types(@TypeId)
    );
END;
GO