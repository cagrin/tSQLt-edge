CREATE PROCEDURE tSQLt.Internal_ExpectNoException
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    INSERT INTO #ExpectException (ExpectException, Message)
    SELECT 0, @Message;
END;
GO