CREATE PROCEDURE tSQLt.AssertObjectExists
    @ObjectName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertObjectExists';
    EXEC @Command
    @ObjectName = @ObjectName,
    @Message = @Message;
END;
GO