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

        EXEC tSQLt.RemoveObject @ObjectName;

        IF PARSENAME(@TableName, 3) IS NOT NULL
        BEGIN
            DECLARE @Execute NVARCHAR(MAX) = CONCAT
            (
                'USE ', QUOTENAME(PARSENAME(@TableName, 3)), '; ',
                'EXEC sys.sp_executesql @CreateTrigger;'
            )

            EXEC sys.sp_executesql @Execute, N'@CreateTrigger NVARCHAR(MAX)', @CreateTrigger;
        END
        ELSE
        BEGIN
            EXEC sys.sp_executesql @CreateTrigger;
        END
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