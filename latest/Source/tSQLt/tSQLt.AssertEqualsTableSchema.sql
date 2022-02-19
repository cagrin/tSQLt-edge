CREATE PROCEDURE tSQLt.AssertEqualsTableSchema
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertEqualsTableSchema';
    EXEC @Command
    @Expected = @Expected,
    @Actual = @Actual,
    @Message = @Message;
END;
GO