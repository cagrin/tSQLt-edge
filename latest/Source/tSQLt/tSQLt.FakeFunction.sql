CREATE PROCEDURE tSQLt.FakeFunction
    @FunctionName NVARCHAR(MAX),
    @FakeFunctionName NVARCHAR(MAX) = NULL,
    @FakeDataSource NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_FakeFunction';
    EXEC @Command
    @FunctionName = @FunctionName,
    @FakeFunctionName = @FakeFunctionName,
    @FakeDataSource = @FakeDataSource;
END;
GO