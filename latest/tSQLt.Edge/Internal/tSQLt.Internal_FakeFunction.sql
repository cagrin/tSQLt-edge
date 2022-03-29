CREATE PROCEDURE tSQLt.Internal_FakeFunction
    @FunctionName NVARCHAR(MAX),
    @FakeFunctionName NVARCHAR(MAX) = NULL,
    @FakeDataSource NVARCHAR(MAX) = NULL
AS
BEGIN
    IF @FakeDataSource IS NOT NULL
        EXEC tSQLt.Fail 'Not implemented yet.';

    DECLARE @ObjectId INT = OBJECT_ID(@FunctionName);
    DECLARE @Parameters NVARCHAR(MAX) = tSQLt.Private_GetParameters (@Objectid);
    DECLARE @ParametersWithTypesDefaultNulls NVARCHAR(MAX) = tSQLt.Private_GetParametersWithTypesDefaultNulls (@Objectid);

    DECLARE @CreateFunctionCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE FUNCTION',
        @FunctionName,
        CONCAT('(', @ParametersWithTypesDefaultNulls, ')'),
        'RETURNS TABLE AS RETURN SELECT * FROM',
        @FakeFunctionName,
        CONCAT('(', @Parameters, ');')
    );

    EXEC tSQLt.Private_RenameObject @ObjectId;
    EXEC (@CreateFunctionCommand);
END;
GO