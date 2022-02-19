CREATE PROCEDURE tSQLt.AssertEqualsString
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertEqualsString';
    EXEC @Command
    @Expected = @Expected,
    @Actual = @Actual,
    @Message = @Message;
END;
GO