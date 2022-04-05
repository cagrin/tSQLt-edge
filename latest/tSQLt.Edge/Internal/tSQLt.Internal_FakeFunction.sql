CREATE PROCEDURE tSQLt.Internal_FakeFunction
    @FunctionName NVARCHAR(MAX),
    @FakeFunctionName NVARCHAR(MAX) = NULL,
    @FakeDataSource NVARCHAR(MAX) = NULL
AS
BEGIN
    EXEC tSQLt.Private_ProcessFakeDataSource @FunctionName, @FakeFunctionName, @FakeDataSource OUTPUT;

    DECLARE @ObjectId INT = OBJECT_ID(@FunctionName);
    DECLARE @CreateFakeFunctionCommand NVARCHAR(MAX);

    IF @FakeDataSource IS NOT NULL
    BEGIN
        DECLARE @ParametersWithTypesDefaultNulls NVARCHAR(MAX) = tSQLt.Private_GetParametersWithTypesDefaultNulls (@Objectid);

        SET @CreateFakeFunctionCommand = CONCAT_WS
        (
            ' ',
            'CREATE FUNCTION', @FunctionName, CONCAT('(', @ParametersWithTypesDefaultNulls, ')'),
            'RETURNS TABLE AS',
            'RETURN', @FakeDataSource
        );
    END
    ELSE
    BEGIN
        DECLARE @ScalarReturnType NVARCHAR(MAX) = tSQLt.Private_GetScalarReturnType (@Objectid);
        DECLARE @ScalarParameters NVARCHAR(MAX) = tSQLt.Private_GetScalarParameters (@Objectid);
        DECLARE @ScalarParametersWithTypesDefaultNulls NVARCHAR(MAX) = tSQLt.Private_GetScalarParametersWithTypesDefaultNulls (@Objectid);

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
    EXEC (@CreateFakeFunctionCommand);
END;
GO