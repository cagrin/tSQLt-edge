CREATE PROCEDURE tSQLt.Internal_ExpectNoException
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    INSERT INTO tSQLt.Private_ExpectException (ExpectException, Message)
    VALUES (0, @Message)
END;
GO