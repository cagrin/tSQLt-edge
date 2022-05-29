CREATE PROCEDURE tSQLt.AssertStringIn
    @Expected tSQLt.AssertStringTable READONLY,
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertStringIn';
    EXEC @Command
    @Expected = @Expected,
    @Actual = @Actual,
    @Message = @Message;
END;