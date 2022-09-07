CREATE PROCEDURE tSQLt.Internal_SpyProcedure
    @ProcedureName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL,
    @CallOriginal BIT = 0,
    @CatchExecutionTimes BIT = 0
AS
BEGIN
    DECLARE @NewName NVARCHAR(MAX) = NEWID();
    DECLARE @ObjectId INT = OBJECT_ID(@ProcedureName);
    DECLARE @Parameters NVARCHAR(MAX);
    EXEC tSQLt.Private_GetParameters @Parameters OUTPUT, @ProcedureName;
    DECLARE @ParametersNames NVARCHAR(MAX);
    EXEC tSQLt.Private_GetParametersNames @ParametersNames OUTPUT, @ProcedureName;
    DECLARE @SpyProcedureLogSelect NVARCHAR(MAX);
    EXEC tSQLt.Private_GetSpyProcedureLogSelect @SpyProcedureLogSelect OUTPUT, @ProcedureName;
    DECLARE @SpyProcedureLogColumns NVARCHAR(MAX);
    EXEC tSQLt.Private_GetSpyProcedureLogColumns @SpyProcedureLogColumns OUTPUT, @ProcedureName;
    DECLARE @ParametersWithTypesDefaultNulls NVARCHAR(MAX);
    EXEC tSQLt.Private_GetParametersWithTypes @ParametersWithTypesDefaultNulls OUTPUT, @ProcedureName, @DefaultNulls = 1;

	DECLARE @LogTableName NVARCHAR(MAX) = CONCAT
	(
		CASE WHEN PARSENAME(@ProcedureName, 3) IS NOT NULL THEN CONCAT(QUOTENAME(PARSENAME(@ProcedureName, 3)), '.') END,
		QUOTENAME(PARSENAME(@ProcedureName, 2)), '.',
		QUOTENAME(CONCAT(PARSENAME(@ProcedureName, 1), '_SpyProcedureLog'))
	);

    DECLARE @InsertIntoLogTableCommand NVARCHAR(MAX) = CONCAT
    (
        'INSERT INTO ',
        @LogTableName,
        CASE WHEN @ParametersNames IS NULL THEN ' DEFAULT VALUES' ELSE CONCAT(' (', @ParametersNames, ') SELECT ', @SpyProcedureLogSelect) END,
        CASE WHEN @CatchExecutionTimes = 1 THEN '; DECLARE @_id_ int = SCOPE_IDENTITY()' END,
        ';'
    );

    DECLARE @SpyProcedureOriginalObjectName NVARCHAR(MAX) = CONCAT
    (
        QUOTENAME(PARSENAME(@ProcedureName, 2)),
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
        CASE WHEN @CatchExecutionTimes = 1 THEN ', _start_ DATETIME2 NOT NULL DEFAULT SYSDATETIME(), _end_ DATETIME2 NULL' END,
        ');'
    );

    DECLARE @CreateProcedureCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE PROCEDURE',
        CONCAT(QUOTENAME(PARSENAME(@ProcedureName, 2)), '.', QUOTENAME(PARSENAME(@ProcedureName, 1))),
        @ParametersWithTypesDefaultNulls,
        'AS BEGIN',
        @InsertIntoLogTableCommand,
        @SpyProcedureOriginalObjectNameVariable,
        @CommandToExecute, NCHAR(10),
        CASE WHEN @CallOriginal = 1 THEN @CallOriginalCommand END,
        CASE WHEN @CatchExecutionTimes = 1 THEN CONCAT_WS(' ', 'UPDATE', @LogTableName, 'SET _end_ = SYSDATETIME() WHERE _id_ = @_id_;') END,
        'RETURN; END;'
    );

    EXEC tSQLt.RemoveObject @LogTableName, @IfExists = 1;
    EXEC tSQLt.RemoveObject @ProcedureName, @NewName OUTPUT;
    EXEC sys.sp_executesql @CreateLogTableCommand;

	IF PARSENAME(@ProcedureName, 3) IS NOT NULL
	BEGIN
		DECLARE @Execute NVARCHAR(MAX) = CONCAT
		(
			'USE ', QUOTENAME(PARSENAME(@ProcedureName, 3)), '; ',
			'EXEC sys.sp_executesql @CreateProcedureCommand;'
		)

		EXEC sys.sp_executesql @Execute, N'@CreateProcedureCommand NVARCHAR(MAX)', @CreateProcedureCommand;
	END
    ELSE
    BEGIN
        EXEC sys.sp_executesql @CreateProcedureCommand;
    END
END;
GO