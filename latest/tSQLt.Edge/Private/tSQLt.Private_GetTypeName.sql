CREATE PROCEDURE tSQLt.Private_GetTypeName
    @TypeName NVARCHAR(MAX) OUTPUT,
    @TypeId INT
AS
BEGIN
    DECLARE @Types tSQLt.System_TypesType
    INSERT INTO @Types
    EXEC tSQLt.System_Types @TypeId

    SELECT
        @TypeName = CASE
            WHEN SCHEMA_NAME(schema_id) <> 'sys' THEN CONCAT(QUOTENAME(SCHEMA_NAME(schema_id)), '.', QUOTENAME(TYPE_NAME(@TypeId)))
            ELSE TYPE_NAME(@TypeId) END
        FROM @Types
END;
GO

CREATE FUNCTION tSQLt.Private_GetTypeName2 (@TypeId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT
        CASE
        WHEN SCHEMA_NAME(schema_id) <> 'sys' THEN CONCAT(QUOTENAME(SCHEMA_NAME(schema_id)), '.', QUOTENAME(TYPE_NAME(@TypeId)))
        ELSE TYPE_NAME(@TypeId) END
        FROM tSQLt.System_Types2(@TypeId)
    );
END;
GO