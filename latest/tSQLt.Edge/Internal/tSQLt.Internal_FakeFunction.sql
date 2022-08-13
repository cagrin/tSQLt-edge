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
        DECLARE @ParametersWithTypesDefaultNulls NVARCHAR(MAX);
        EXEC tSQLt.Private_GetParametersWithTypes @ParametersWithTypesDefaultNulls OUTPUT, @ObjectId, @DefaultNulls = 1;

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
        DECLARE @ScalarReturnType NVARCHAR(MAX);
        EXEC tSQLt.Private_GetScalarReturnType @ScalarReturnType OUTPUT, @ObjectId;
        DECLARE @ScalarParameters NVARCHAR(MAX);
        EXEC tSQLt.Private_GetScalarParameters @ScalarParameters OUTPUT, @ObjectId;
        DECLARE @ScalarParametersWithTypesDefaultNulls NVARCHAR(MAX);
        EXEC tSQLt.Private_GetParametersWithTypes @ScalarParametersWithTypesDefaultNulls OUTPUT, @ObjectId, @DefaultNulls = 1, @Scalar = 1;

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