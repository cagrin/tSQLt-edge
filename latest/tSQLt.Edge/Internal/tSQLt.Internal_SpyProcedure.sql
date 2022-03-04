CREATE PROCEDURE tSQLt.Internal_SpyProcedure
    @ProcedureName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @ObjectId INT = OBJECT_ID(@ProcedureName);
    DECLARE @Parameters NVARCHAR(MAX) = tSQLt.Private_GetParameters (@Objectid);
    DECLARE @Columns NVARCHAR(MAX) = tSQLt.Private_GetColumns (@Objectid);
    DECLARE @ParametersWithTypes NVARCHAR(MAX) = tSQLt.Private_GetParametersWithTypes (@Objectid);
    DECLARE @ColumnsWithTypes NVARCHAR(MAX) = tSQLt.Private_GetColumnsWithTypes (@Objectid);
    DECLARE @LogTableName NVARCHAR(MAX) = CONCAT(QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)), '.', QUOTENAME(CONCAT(OBJECT_NAME(@ObjectId), '_SpyProcedureLog')));

    DECLARE @InsertIntoLogTableCommand NVARCHAR(MAX) = CONCAT
    (
        'INSERT INTO ',
        @LogTableName,
        CASE WHEN @Columns IS NULL THEN ' DEFAULT VALUES' ELSE CONCAT(' (', @Columns, ') SELECT ', @Parameters) END,
        ';'
    );

    DECLARE @CreateLogTableCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE TABLE',
        @LogTableName,
        '(_id_ int IDENTITY(1, 1) PRIMARY KEY CLUSTERED',
        CASE WHEN @ColumnsWithTypes IS NULL THEN '' ELSE CONCAT(', ', @ColumnsWithTypes) END,
        ');'
    );

    DECLARE @CreateProcedureCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE PROCEDURE',
        @ProcedureName,
        @ParametersWithTypes,
        'AS BEGIN',
        @InsertIntoLogTableCommand,
        @CommandToExecute,
        'RETURN; END;'
    );

    EXEC tSQLt.Private_RenameObject @ObjectId;
    EXEC (@CreateLogTableCommand);
    EXEC (@CreateProcedureCommand);
END;
GO