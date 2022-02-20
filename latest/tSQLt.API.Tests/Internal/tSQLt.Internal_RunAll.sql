CREATE PROCEDURE tSQLt.Internal_RunAll
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = '
    DECLARE @Command NVARCHAR(MAX);
    SELECT @Command = STRING_AGG(CONVERT(NVARCHAR(MAX),''EXEC ('''''' + REPLACE(command, '''''''', '''''''''''') + '''''');''), CHAR(13)+ CHAR(10))
    FROM
    (

        SELECT
        command = ''CREATE PROCEDURE '' + REPLACE(spname, ''.['', ''.[Internal_'') + ISNULL('' '' + STRING_AGG(name + '' '' + default_value, '', '') WITHIN GROUP (ORDER BY parameter_id), '''')
            + '' AS BEGIN''
            + '' PRINT CONCAT_WS('''' '''', ''''- '' + spname + '''''', '' + STRING_AGG(CONVERT(NVARCHAR(MAX),pname), '', '') + '');''
            + '' END;''
        FROM
        (
            SELECT TOP (100) PERCENT
                spname = QUOTENAME(SCHEMA_NAME(r.schema_id)) + ''.'' + QUOTENAME(r.name),
                p.name,
                pname = CASE
                    WHEN p.system_type_id <> 231  THEN '''''''' + p.name + ''''''''
                    ELSE p.name
                    END,
                default_value = CASE
                    WHEN p.system_type_id = 231 THEN ''NVARCHAR(MAX)''
                    WHEN p.system_type_id = 104 THEN ''BIT''
                    WHEN p.system_type_id = 98 THEN ''SQL_VARIANT''
                    WHEN p.system_type_id = 56 THEN ''INT''
                    END,
                p.parameter_id
            FROM sys.procedures r
            LEFT JOIN sys.parameters p
            ON p.object_id = r.object_id
            WHERE SCHEMA_NAME(r.schema_id) = ''tSQLt''
            AND r.name <> ''RunAll''
            ORDER BY r.name, p.parameter_id
        ) A
        GROUP BY spname
    ) B

    EXEC (@Command);

    SELECT @Command = STRING_AGG(command, CHAR(13))
    FROM
    (
        SELECT command = ''EXEC '' + spname + ISNULL('' '' + STRING_AGG(name + '' = '' + default_value, '', '') WITHIN GROUP (ORDER BY parameter_id), '''') + '';''
        FROM
        (
            SELECT TOP (100) PERCENT
                spname = QUOTENAME(SCHEMA_NAME(r.schema_id)) + ''.'' + QUOTENAME(r.name),
                p.name,
                default_value = CASE WHEN p.system_type_id = 231 THEN '''''''' + p.name + '''''''' ELSE ''NULL'' END,
                p.parameter_id
            FROM sys.procedures r
            LEFT JOIN sys.parameters p
            ON p.object_id = r.object_id
            WHERE SCHEMA_NAME(r.schema_id) = ''tSQLt''
            AND r.name NOT LIKE ''Internal%''
            AND r.name <> ''RunAll''
            ORDER BY r.name, p.parameter_id
        ) A
        GROUP BY spname
    ) B

    EXEC (@Command);
    ';
    EXEC (@Command);
END;
GO