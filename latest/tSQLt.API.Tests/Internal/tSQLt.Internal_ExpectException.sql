CREATE PROCEDURE tSQLt.Internal_ExpectException
    @ExpectedMessage NVARCHAR(MAX) = NULL,
    @ExpectedSeverity INT = NULL,
    @ExpectedState INT = NULL,
    @Message NVARCHAR(MAX) = NULL,
    @ExpectedMessagePattern NVARCHAR(MAX) = NULL,
    @ExpectedErrorNumber INT = NULL
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.ExpectException', @ExpectedMessage, '@ExpectedSeverity', '@ExpectedState', @Message, @ExpectedMessagePattern, '@ExpectedErrorNumber');
END;
GO