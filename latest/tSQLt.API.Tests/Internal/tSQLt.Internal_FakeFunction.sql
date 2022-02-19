CREATE PROCEDURE tSQLt.Internal_FakeFunction
    @FunctionName NVARCHAR(MAX),
    @FakeFunctionName NVARCHAR(MAX) = NULL,
    @FakeDataSource NVARCHAR(MAX) = NULL
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.FakeFunction', @FunctionName, @FakeFunctionName, @FakeDataSource);
END;
GO