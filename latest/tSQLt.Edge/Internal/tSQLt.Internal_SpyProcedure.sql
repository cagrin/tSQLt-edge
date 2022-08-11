CREATE PROCEDURE tSQLt.Internal_SpyProcedure
    @ProcedureName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL,
    @CallOriginal BIT = 0
AS
BEGIN
    DECLARE @NewName NVARCHAR(MAX) = NEWID();
    DECLARE @ObjectId INT = OBJECT_ID(@ProcedureName);
    DECLARE @Parameters NVARCHAR(MAX) = tSQLt.Private_GetParameters (@Objectid);
    DECLARE @ParametersNames NVARCHAR(MAX) = tSQLt.Private_GetParametersNames (@Objectid);
    DECLARE @SpyProcedureLogSelect NVARCHAR(MAX) = tSQLt.Private_GetSpyProcedureLogSelect (@Objectid);
    DECLARE @SpyProcedureLogColumns NVARCHAR(MAX);
    EXEC tSQLt.Private_GetSpyProcedureLogColumns @SpyProcedureLogColumns OUTPUT, @ObjectId;
    DECLARE @ParametersWithTypesDefaultNulls NVARCHAR(MAX) = tSQLt.Private_GetParametersWithTypesDefaultNulls (@Objectid);
    DECLARE @LogTableName NVARCHAR(MAX) = CONCAT(QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)), '.', QUOTENAME(CONCAT(OBJECT_NAME(@ObjectId), '_SpyProcedureLog')));

    DECLARE @InsertIntoLogTableCommand NVARCHAR(MAX) = CONCAT
    (
        'INSERT INTO ',
        @LogTableName,
        CASE WHEN @ParametersNames IS NULL THEN ' DEFAULT VALUES' ELSE CONCAT(' (', @ParametersNames, ') SELECT ', @SpyProcedureLogSelect) END,
        ';'
    );

    DECLARE @SpyProcedureOriginalObjectName NVARCHAR(MAX) = CONCAT
    (
        QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)),
        '.',
        QUOTENAME(@NewName)
    );

    DECLARE @SpyProcedureOriginalObjectNameVariable NVARCHAR(MAX) = CONCAT
    (
        'DECLARE @SpyProcedureOriginalObjectName NVARCHAR(MAX) = ''',
        REPLACE(@SpyProcedureOriginalObjectName, '''', ''''''),
        ''''
    );

    DECLARE @CallOriginalCommand NVARCHAR(MAX) = CONCAT
    (
        'EXEC @SpyProcedureOriginalObjectName ',
        @Parameters,
        ';'
    );

    DECLARE @CreateLogTableCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE TABLE',
        @LogTableName,
        '(_id_ int IDENTITY(1, 1) PRIMARY KEY CLUSTERED',
        CASE WHEN @SpyProcedureLogColumns IS NULL THEN '' ELSE CONCAT(', ', @SpyProcedureLogColumns) END,
        ');'
    );

    DECLARE @CreateProcedureCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE PROCEDURE',
        @ProcedureName,
        @ParametersWithTypesDefaultNulls,
        'AS BEGIN',
        @InsertIntoLogTableCommand,
        @SpyProcedureOriginalObjectNameVariable,
        @CommandToExecute, NCHAR(10),
        CASE WHEN @CallOriginal = 1 THEN @CallOriginalCommand END,
        'RETURN; END;'
    );

    EXEC tSQLt.Internal_RemoveObject @LogTableName, @IfExists = 1;
    EXEC tSQLt.Internal_RemoveObject @ProcedureName, @NewName OUTPUT;
    EXEC (@CreateLogTableCommand);
    EXEC (@CreateProcedureCommand);
END;
GO