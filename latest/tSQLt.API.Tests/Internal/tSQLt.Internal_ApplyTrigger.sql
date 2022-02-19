CREATE PROCEDURE tSQLt.Internal_ApplyTrigger
    @TableName NVARCHAR(MAX),
    @TriggerName NVARCHAR(MAX)
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.ApplyTrigger', @TableName, @TriggerName);
END;
GO