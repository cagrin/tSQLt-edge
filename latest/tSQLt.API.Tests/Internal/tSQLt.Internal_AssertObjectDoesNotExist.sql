CREATE PROCEDURE tSQLt.Internal_AssertObjectDoesNotExist
    @ObjectName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.AssertObjectDoesNotExist', @ObjectName, @Message);
END;
GO