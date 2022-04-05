CREATE PROCEDURE tSQLt.Internal_FakeFunction
    @FunctionName NVARCHAR(MAX),
    @FakeFunctionName NVARCHAR(MAX) = NULL,
    @FakeDataSource NVARCHAR(MAX) = NULL
AS
BEGIN
    IF @FakeFunctionName IS NULL AND @FakeDataSource IS NULL
        EXEC tSQLt.Fail 'Either @FakeFunctionName or @FakeDataSource must be provided.';

    IF @FakeFunctionName IS NOT NULL AND @FakeDataSource IS NOT NULL
        EXEC tSQLt.Fail 'Both @FakeFunctionName and @FakeDataSource are valued. Please use only one.';

    EXEC tSQLt.AssertObjectExists @FunctionName;

    IF @FakeDataSource IS NULL
        EXEC tSQLt.AssertObjectExists @FakeFunctionName;

    DECLARE @ObjectId INT = OBJECT_ID(@FunctionName);
    DECLARE @FunctionType CHAR(2) = tSQLt.Private_GetObjectType (@ObjectId);

    DECLARE @CreateFakeFunctionCommand NVARCHAR(MAX);
    IF @FunctionType IN ('IF', 'TF')
    BEGIN
        DECLARE @Parameters NVARCHAR(MAX) = tSQLt.Private_GetParameters (@Objectid);
        DECLARE @ParametersWithTypesDefaultNulls NVARCHAR(MAX) = tSQLt.Private_GetParametersWithTypesDefaultNulls (@Objectid);

        IF @FakeDataSource IS NULL
        BEGIN
            SET @FakeDataSource = CONCAT('SELECT * FROM ', @FakeFunctionName, ' (', @Parameters, ');');
        END
        ELSE
        BEGIN
            IF (UPPER(@FakeDataSource) LIKE 'SELECT%' AND OBJECT_ID(@FakeDataSource) IS NULL)
            BEGIN
                SET @FakeDataSource = CONCAT('(', @FakeDataSource, ') A ');
            END
            SET @FakeDataSource = CONCAT('(SELECT * FROM ', @FakeDataSource, ');');
        END

        SET @CreateFakeFunctionCommand = CONCAT_WS
        (
            ' ',
            'CREATE FUNCTION', @FunctionName, CONCAT('(', @ParametersWithTypesDefaultNulls, ')'),
            'RETURNS TABLE AS RETURN', @FakeDataSource
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

    EXEC tSQLt.Private_RenameObject @FunctionName;
    EXEC (@CreateFakeFunctionCommand);
END;
GO