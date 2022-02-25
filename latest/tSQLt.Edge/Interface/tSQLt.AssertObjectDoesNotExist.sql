CREATE PROCEDURE tSQLt.AssertObjectDoesNotExist
    @ObjectName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertObjectDoesNotExist';
    EXEC @Command
    @ObjectName = @ObjectName,
    @Message = @Message;
END;
GO