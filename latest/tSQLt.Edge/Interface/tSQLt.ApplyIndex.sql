CREATE PROCEDURE tSQLt.ApplyIndex
    @TableName NVARCHAR(MAX),
    @IndexName NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_ApplyIndex';
    EXEC @Command
    @TableName = @TableName,
    @IndexName = @IndexName;
END;
GO