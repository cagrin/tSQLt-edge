CREATE PROCEDURE tSQLt.Private_ProcessFakeDataSource
    @FunctionName NVARCHAR(MAX),
    @FakeFunctionName NVARCHAR(MAX) = NULL,
    @FakeDataSource NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    IF @FakeFunctionName IS NULL AND @FakeDataSource IS NULL
        EXEC tSQLt.Fail 'Either @FakeFunctionName or @FakeDataSource must be provided.';

    IF @FakeFunctionName IS NOT NULL AND @FakeDataSource IS NOT NULL
        EXEC tSQLt.Fail 'Both @FakeFunctionName and @FakeDataSource are valued. Please use only one.';

    EXEC tSQLt.AssertObjectExists @FunctionName;

    DECLARE @ObjectId INT = OBJECT_ID(@FunctionName);
    DECLARE @FunctionType CHAR(2) = tSQLt.Private_GetObjectType (@ObjectId);

    IF @FakeDataSource IS NULL
    BEGIN
        EXEC tSQLt.AssertObjectExists @FakeFunctionName;

        DECLARE @FakeObjectId INT = OBJECT_ID(@FakeFunctionName);
        DECLARE @FakeFunctionType CHAR(2) = tSQLt.Private_GetObjectType (@FakeObjectId);

        DECLARE @ParametersWithTypes NVARCHAR(MAX) = tSQLt.Private_GetParametersWithTypes (@Objectid);
        DECLARE @FakeParametersWithTypes NVARCHAR(MAX) = tSQLt.Private_GetParametersWithTypes (@FakeObjectId);

        IF @ParametersWithTypes <> @FakeParametersWithTypes
            EXEC tSQLt.Fail 'Parameters of both functions must match! (This includes the return type for scalar functions.)';
    END

    DECLARE @CreateFakeFunctionCommand NVARCHAR(MAX);
    IF @FunctionType IN ('IF', 'TF') AND (@FakeFunctionType IN ('IF', 'TF') OR @FakeDataSource IS NOT NULL)
    BEGIN
        IF @FakeDataSource IS NULL
        BEGIN
            DECLARE @Parameters NVARCHAR(MAX) = tSQLt.Private_GetParameters (@Objectid);
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
    END
    ELSE IF @FunctionType IN ('FN') AND @FakeFunctionType IN ('FN') AND @FakeDataSource IS NULL
    BEGIN
        SET @FakeDataSource = NULL
    END
    ELSE
        EXEC tSQLt.Fail 'Both parameters must contain the name of either scalar or table valued functions';
END;
GO