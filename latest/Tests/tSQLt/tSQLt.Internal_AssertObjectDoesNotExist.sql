CREATE PROCEDURE tSQLt.Internal_AssertObjectDoesNotExist
    @ObjectName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT '- tSQLt.AssertObjectDoesNotExist';
END;
GO