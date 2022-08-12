CREATE PROCEDURE tSQLt.Internal_ApplyTrigger
    @TableName NVARCHAR(MAX),
    @TriggerName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @ObjectName NVARCHAR(MAX), @TriggerId INT;
    EXEC tSQLt.Private_ProcessTriggerName @ObjectName OUTPUT, @TriggerId OUTPUT, @TableName, @TriggerName;

    DECLARE @System_SqlModules tSQLt.System_SqlModulesType
    INSERT INTO @System_SqlModules
    EXEC tSQLt.System_SqlModules

    IF @TriggerId IS NOT NULL
    BEGIN
        DECLARE @CreateTrigger NVARCHAR(MAX) =
        (
            SELECT [definition]
            FROM @System_SqlModules
            WHERE object_id = @TriggerId
        )

        EXEC tSQLt.RemoveObject @ObjectName;
        EXEC (@CreateTrigger);
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.ApplyTrigger failed.',
            CONCAT('Trigger:<', @TriggerName, '> on table <', @TableName,'> does not exist.')
        );
        EXEC tSQLt.Fail @Failed;
    END
END;
GO