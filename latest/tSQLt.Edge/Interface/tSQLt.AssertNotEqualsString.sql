CREATE PROCEDURE tSQLt.AssertNotEqualsString
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertNotEqualsString';
    EXEC @Command
    @Expected = @Expected,
    @Actual = @Actual,
    @Message = @Message;
END;
GO