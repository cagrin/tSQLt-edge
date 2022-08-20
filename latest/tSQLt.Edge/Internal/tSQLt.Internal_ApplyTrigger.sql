CREATE PROCEDURE tSQLt.Internal_ApplyTrigger
    @TableName NVARCHAR(MAX),
    @TriggerName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @ObjectName NVARCHAR(MAX);
    EXEC tSQLt.Private_ProcessTriggerName @ObjectName OUTPUT, @TableName, @TriggerName;

    DECLARE @System_SqlModules tSQLt.System_SqlModulesType
    INSERT INTO @System_SqlModules
    EXEC tSQLt.System_SqlModules @ObjectName

    IF OBJECT_ID(@ObjectName, 'TR') IS NOT NULL
    BEGIN
        DECLARE @CreateTrigger NVARCHAR(MAX) =
        (
            SELECT [definition]
            FROM @System_SqlModules
        )

        IF PARSENAME(@TableName, 3) IS NOT NULL
        BEGIN
            SET @CreateTrigger = CONCAT
            (
                'EXEC(''USE ', QUOTENAME(PARSENAME(@TableName, 3)), '; ',
                'EXEC(''''', REPLACE(@CreateTrigger, '''', ''''''''''), ''''')'')'
            )
        END

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