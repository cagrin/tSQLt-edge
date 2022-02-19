CREATE PROCEDURE tSQLt.ExpectException
    @ExpectedMessage NVARCHAR(MAX) = NULL,
    @ExpectedSeverity INT = NULL,
    @ExpectedState INT = NULL,
    @Message NVARCHAR(MAX) = NULL,
    @ExpectedMessagePattern NVARCHAR(MAX) = NULL,
    @ExpectedErrorNumber INT = NULL
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_ExpectException';
    EXEC @Command
    @ExpectedMessage = @ExpectedMessage,
    @ExpectedSeverity = @ExpectedSeverity,
    @ExpectedState = @ExpectedState,
    @Message = @Message,
    @ExpectedMessagePattern = @ExpectedMessagePattern,
    @ExpectedErrorNumber = @ExpectedErrorNumber;
END;
GO