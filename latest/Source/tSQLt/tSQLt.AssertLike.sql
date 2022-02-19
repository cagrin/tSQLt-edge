CREATE PROCEDURE tSQLt.AssertLike
    @ExpectedPattern NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertLike';
    EXEC @Command
    @ExpectedPattern = @ExpectedPattern,
    @Actual = @Actual,
    @Message = @Message;
END;
GO