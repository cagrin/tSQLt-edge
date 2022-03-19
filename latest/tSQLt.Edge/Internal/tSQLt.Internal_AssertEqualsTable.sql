CREATE PROCEDURE tSQLt.Internal_AssertEqualsTable
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL,
    @FailMsg NVARCHAR(MAX) = 'Unexpected/missing resultset rows!'
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @diffs INT;

    SET @sql =
    '
    SELECT @diffs = COUNT(*) FROM
    (
        SELECT ''' + @Expected + ''' AS table_name, * FROM
        (
            SELECT * FROM ' + @Expected + '
            EXCEPT
            SELECT * FROM ' + @Actual + '
        ) x

        UNION ALL

        SELECT ''' + @Actual + ''' AS table_name, * FROM
        (
            SELECT * FROM ' + @Actual + '
            EXCEPT
            SELECT * FROM ' + @Expected + '
        ) y
    ) z
    ';

    EXEC sp_executesql @sql, N'@diffs INT OUTPUT', @diffs OUTPUT

    IF @diffs > 0
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT
        (
            'tSQLt.AssertEqualsTable failed. Expected:<',
            @Expected,
            '> has different rowset than Actual:<',
            @Actual,
            '>.'
        );
        EXEC tSQLt.Fail @Message0 = @Failed;
    END
END;
GO