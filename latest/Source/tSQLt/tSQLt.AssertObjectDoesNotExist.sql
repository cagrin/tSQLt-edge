CREATE PROCEDURE tSQLt.AssertObjectDoesNotExist
    @ObjectName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT '- tSQLt.AssertObjectDoesNotExist';
END;
GO