CREATE PROCEDURE tSQLt.AssertNotEquals
    @Expected SQL_VARIANT,
    @Actual SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertNotEquals';
    EXEC @Command
    @Expected = @Expected,
    @Actual = @Actual,
    @Message = @Message;
END;
GO