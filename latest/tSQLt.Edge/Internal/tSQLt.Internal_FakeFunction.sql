CREATE PROCEDURE tSQLt.Internal_FakeFunction
    @FunctionName NVARCHAR(MAX),
    @FakeFunctionName NVARCHAR(MAX) = NULL,
    @FakeDataSource NVARCHAR(MAX) = NULL
AS
BEGIN
    EXEC tSQLt.Private_ProcessFakeDataSource @FunctionName, @FakeFunctionName, @FakeDataSource OUTPUT;

    DECLARE @CreateFakeFunctionCommand NVARCHAR(MAX);

    IF @FakeDataSource IS NOT NULL
    BEGIN
        DECLARE @ParametersWithTypesDefaultNulls NVARCHAR(MAX);
        EXEC tSQLt.Private_GetParametersWithTypes @ParametersWithTypesDefaultNulls OUTPUT, @FunctionName, @DefaultNulls = 1;

        SET @CreateFakeFunctionCommand = CONCAT_WS
        (
            ' ',
            'CREATE FUNCTION', CONCAT(QUOTENAME(PARSENAME(@FunctionName, 2)), '.', QUOTENAME(PARSENAME(@FunctionName, 1))), CONCAT('(', @ParametersWithTypesDefaultNulls, ')'),
            'RETURNS TABLE AS',
            'RETURN', @FakeDataSource
        );
    END
    ELSE
    BEGIN
        DECLARE @ScalarReturnType NVARCHAR(MAX);
        EXEC tSQLt.Private_GetScalarReturnType @ScalarReturnType OUTPUT, @FunctionName;
        DECLARE @ScalarParameters NVARCHAR(MAX);
        EXEC tSQLt.Private_GetScalarParameters @ScalarParameters OUTPUT, @FunctionName;
        DECLARE @ScalarParametersWithTypesDefaultNulls NVARCHAR(MAX);
        EXEC tSQLt.Private_GetParametersWithTypes @ScalarParametersWithTypesDefaultNulls OUTPUT, @FunctionName, @DefaultNulls = 1, @Scalar = 1;

        SET @CreateFakeFunctionCommand = CONCAT_WS
        (
            ' ',
            'CREATE FUNCTION', @FunctionName, CONCAT('(', @ScalarParametersWithTypesDefaultNulls, ')'),
            'RETURNS', @ScalarReturnType,
            'AS BEGIN',
            'RETURN', @FakeFunctionName, CONCAT('(', @ScalarParameters, ');'),
            'END;'
        );
    END

    EXEC tSQLt.Private_RenameObject @FunctionName;

	IF PARSENAME(@FunctionName, 3) IS NOT NULL
	BEGIN
		DECLARE @Execute NVARCHAR(MAX) = CONCAT
		(
			'USE ', QUOTENAME(PARSENAME(@FunctionName, 3)), '; ',
			'EXEC sys.sp_executesql @CreateFakeFunctionCommand;'
		)

		EXEC sys.sp_executesql @Execute, N'@CreateFakeFunctionCommand NVARCHAR(MAX)', @CreateFakeFunctionCommand;
	END
    ELSE
    BEGIN
        EXEC sys.sp_executesql @CreateFakeFunctionCommand;
    END
END;
GO