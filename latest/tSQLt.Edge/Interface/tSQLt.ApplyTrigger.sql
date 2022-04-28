CREATE PROCEDURE tSQLt.ApplyTrigger
    @TableName NVARCHAR(MAX),
    @TriggerName NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_ApplyTrigger';
    EXEC @Command
    @TableName = @TableName,
    @TriggerName = @TriggerName;
END;
GO