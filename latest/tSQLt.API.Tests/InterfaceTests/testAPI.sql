CREATE SCHEMA testAPI;
GO

CREATE PROCEDURE testAPI.RunAll
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = '
    DECLARE @Command NVARCHAR(MAX);
    SELECT @Command = STRING_AGG(command, CHAR(13))
    FROM
    (
        SELECT ''EXEC '' + spname + ISNULL('' '' + STRING_AGG(name + '' = '' + default_value, '', '') WITHIN GROUP (ORDER BY parameter_id), '''') + '';'' AS command
        FROM
        (
            SELECT TOP (100) PERCENT
                QUOTENAME(SCHEMA_NAME(r.schema_id)) + ''.'' + QUOTENAME(r.name) AS spname,
                p.name,
                default_value = CASE WHEN p.system_type_id = 231 THEN '''''''' + p.name + '''''''' ELSE ''NULL'' END,
                p.parameter_id
            FROM sys.procedures r
            LEFT JOIN sys.parameters p
            ON p.object_id = r.object_id
            WHERE SCHEMA_NAME(r.schema_id) = ''tSQLt''
            AND r.name NOT LIKE ''Internal%''
            ORDER BY r.name, p.parameter_id
        ) A
        GROUP BY spname
    ) B

    EXEC (@Command);
    ';
    EXEC (@Command);
END;
GO