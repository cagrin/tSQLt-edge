CREATE PROCEDURE tSQLt.Internal_ExpectException
    @ExpectedMessage NVARCHAR(MAX) = NULL,
    @ExpectedSeverity INT = NULL,
    @ExpectedState INT = NULL,
    @Message NVARCHAR(MAX) = NULL,
    @ExpectedMessagePattern NVARCHAR(MAX) = NULL,
    @ExpectedErrorNumber INT = NULL
AS
BEGIN
    INSERT INTO #ExpectException (ExpectException, ExpectedMessage, Message)
    SELECT 1, @ExpectedMessage, @Message;
END;
GO