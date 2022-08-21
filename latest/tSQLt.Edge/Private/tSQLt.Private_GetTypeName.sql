CREATE PROCEDURE tSQLt.Private_GetTypeName
    @ObjectName NVARCHAR(MAX),
    @TypeName NVARCHAR(MAX) OUTPUT,
    @TypeId INT
AS
BEGIN
    DECLARE @Types tSQLt.System_TypesType
    INSERT INTO @Types
    EXEC tSQLt.System_Types @ObjectName, @TypeId

    SELECT
        @TypeName = CASE
            WHEN schema_name <> 'sys' THEN CONCAT(QUOTENAME(schema_name), '.', QUOTENAME(TYPE_NAME(@TypeId)))
            ELSE TYPE_NAME(@TypeId) END
        FROM @Types
END;
GO