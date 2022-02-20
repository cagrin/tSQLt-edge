CREATE PROCEDURE tSQLt.Internal_RunAll
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = '
    DECLARE @Command NVARCHAR(MAX);
    SELECT @Command = STRING_AGG(command, CHAR(13))
    FROM
    (
        SELECT command = ''EXEC '' + spname + '';''
        FROM
        (
            SELECT TOP (100) PERCENT
                spname = QUOTENAME(SCHEMA_NAME(r.schema_id)) + ''.'' + QUOTENAME(r.name)
            FROM sys.procedures r
            LEFT JOIN sys.parameters p
            ON p.object_id = r.object_id
            WHERE SCHEMA_NAME(r.schema_id) <> ''tSQLt''
            AND r.name LIKE ''test%''
            AND p.parameter_id IS NULL
            ORDER BY r.name
        ) A
        GROUP BY spname
    ) B

    EXEC (@Command);
    ';
    EXEC (@Command);
END;
GO