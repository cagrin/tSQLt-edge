CREATE PROCEDURE tSQLt.Internal_AssertObjectExists
    @ObjectName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.AssertObjectExists', @ObjectName, @Message);
END;
GO