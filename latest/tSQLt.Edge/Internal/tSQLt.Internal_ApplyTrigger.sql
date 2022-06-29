CREATE PROCEDURE tSQLt.Internal_ApplyTrigger
    @TableName NVARCHAR(MAX),
    @TriggerName NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.AssertObjectExists @TableName;

    SET @TriggerName = CONCAT(OBJECT_SCHEMA_NAME(OBJECT_ID(@TableName)), '.', @TriggerName);
    EXEC tSQLt.AssertObjectExists @TriggerName;

    DECLARE @CreateTrigger NVARCHAR(MAX) =
    (
        SELECT [definition]
        FROM tSQLt.System_SqlModules()
        WHERE object_id = OBJECT_ID(@TriggerName)
    )

    EXEC tSQLt.RemoveObject @TriggerName;
    EXEC (@CreateTrigger);
END;
GO