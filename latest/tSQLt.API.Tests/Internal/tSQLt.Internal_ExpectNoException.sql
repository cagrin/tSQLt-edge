CREATE PROCEDURE tSQLt.Internal_ExpectNoException
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.ExpectNoException', @Message);
END;
GO