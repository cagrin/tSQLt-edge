CREATE PROCEDURE tSQLt.Internal_FakeFunction
    @FunctionName NVARCHAR(MAX),
    @FakeFunctionName NVARCHAR(MAX) = NULL,
    @FakeDataSource NVARCHAR(MAX) = NULL
AS
BEGIN
    EXEC tSQLt.AssertObjectExists @FunctionName;
    EXEC tSQLt.AssertObjectExists @FakeFunctionName;
    EXEC tSQLt.AssertEqualsString NULL, @FakeDataSource, @Message = 'FakeDataSource is not implemented yet.';

    DECLARE @ObjectId INT = OBJECT_ID(@FunctionName);
    DECLARE @FunctionType CHAR(2) = tSQLt.Private_GetObjectType (@ObjectId);

    DECLARE @CreateFakeFunctionCommand NVARCHAR(MAX);
    IF @FunctionType IN ('IF', 'TF')
    BEGIN
        DECLARE @Parameters NVARCHAR(MAX) = tSQLt.Private_GetParameters (@Objectid);
        DECLARE @ParametersWithTypesDefaultNulls NVARCHAR(MAX) = tSQLt.Private_GetParametersWithTypesDefaultNulls (@Objectid);

        SET @CreateFakeFunctionCommand = CONCAT_WS
        (
            ' ',
            'CREATE FUNCTION', @FunctionName, CONCAT('(', @ParametersWithTypesDefaultNulls, ')'),
            'RETURNS TABLE AS',
            'RETURN SELECT * FROM', @FakeFunctionName, CONCAT('(', @Parameters, ');')
        );
    END
    ELSE IF @FunctionType IN ('FN')
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
    ELSE
        EXEC tSQLt.Fail 'Unsupported function type', @FunctionType;

    EXEC tSQLt.Private_RenameObject @ObjectId;
    EXEC (@CreateFakeFunctionCommand);
END;
GO