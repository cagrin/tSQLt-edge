CREATE PROCEDURE tSQLt.Private_ProcessUncomparableColumns
    @ObjectName NVARCHAR(MAX) OUTPUT
AS
BEGIN
    DECLARE @System_Columns tSQLt.System_ColumnsType;
    INSERT INTO @System_Columns
    EXEC tSQLt.System_Columns @ObjectName

    DECLARE @OutputName NVARCHAR(MAX) = QUOTENAME(NEWID());
    DECLARE @Command NVARCHAR(MAX) =
    (
        SELECT
            STRING_AGG
            (
                CONCAT_WS
                (
                    ' ',
                    'ALTER TABLE',
                    @OutputName,
                    'ALTER COLUMN',
                    QUOTENAME(name),
                    'NVARCHAR(MAX)',
                    CASE is_nullable WHEN 1 THEN 'NULL' ELSE 'NOT NULL' END
                ),
                '; '
            ) WITHIN GROUP (ORDER BY column_id)
        FROM @System_Columns
        WHERE TYPE_NAME(user_type_id) IN ('xml')
    );

    IF @Command IS NOT NULL
    BEGIN
        SET @Command =
        (
            SELECT CONCAT_WS
            (
                ' ',
                'SELECT * INTO',
                @OutputName,
                'FROM',
                @ObjectName,
                @Command
            )
        );

        EXEC sys.sp_executesql @Command;

        SET @ObjectName = @OutputName;
    END
END;
GO