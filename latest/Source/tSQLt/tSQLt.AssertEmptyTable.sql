CREATE PROCEDURE tSQLt.AssertEmptyTable
    @TableName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertEmptyTable';
    EXEC @Command
    @TableName = @TableName,
    @Message = @Message;
END;
GO