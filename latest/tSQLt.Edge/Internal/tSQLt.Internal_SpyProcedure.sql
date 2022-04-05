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
    DECLARE @ParametersNamesWithTypes NVARCHAR(MAX) = tSQLt.Private_GetParametersNamesWithTypes (@Objectid);
    DECLARE @ParametersWithTypesDefaultNulls NVARCHAR(MAX) = tSQLt.Private_GetParametersWithTypesDefaultNulls (@Objectid);
    DECLARE @LogTableName NVARCHAR(MAX) = CONCAT(QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)), '.', QUOTENAME(CONCAT(OBJECT_NAME(@ObjectId), '_SpyProcedureLog')));

    DECLARE @InsertIntoLogTableCommand NVARCHAR(MAX) = CONCAT
    (
        'INSERT INTO ',
        @LogTableName,
        CASE WHEN @ParametersNames IS NULL THEN ' DEFAULT VALUES' ELSE CONCAT(' (', @ParametersNames, ') SELECT ', @Parameters) END,
        ';'
    );

    DECLARE @CallOriginalCommand NVARCHAR(MAX) = CONCAT
    (
        'EXEC ',
        QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)), '.', QUOTENAME(@NewName),
        ' ',
        @Parameters,
        ';'
    );

    DECLARE @CreateLogTableCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE TABLE',
        @LogTableName,
        '(_id_ int IDENTITY(1, 1) PRIMARY KEY CLUSTERED',
        CASE WHEN @ParametersNamesWithTypes IS NULL THEN '' ELSE CONCAT(', ', @ParametersNamesWithTypes) END,
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
        @CommandToExecute,
        CASE WHEN @CallOriginal = 1 THEN @CallOriginalCommand END,
        'RETURN; END;'
    );

    EXEC tSQLt.Private_RenameObject @ProcedureName, @NewName OUTPUT;
    EXEC (@CreateLogTableCommand);
    EXEC (@CreateProcedureCommand);
END;
GO