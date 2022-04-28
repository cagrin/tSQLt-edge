CREATE PROCEDURE tSQLt.AssertEmptyTable
    @TableName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertEmptyTable';
    EXEC @Command
    @TableName = @TableName,
    @Message = @Message;
END;
GO