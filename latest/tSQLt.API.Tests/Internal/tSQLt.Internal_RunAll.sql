CREATE PROCEDURE tSQLt.Internal_RunAll
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX);
    
    SELECT @Command = STRING_AGG(CONVERT(NVARCHAR(MAX), FORMATMESSAGE('EXEC (''%s'');', REPLACE(command, '''', ''''''))), CHAR(13))
    FROM
    (
        SELECT
            command = FORMATMESSAGE
            (
                'CREATE PROCEDURE %s%s AS BEGIN PRINT ''%s, %s''; END;',
                REPLACE(spname, '.[', '.[Internal_'),
                STRING_AGG(pvalue, ',') WITHIN GROUP (ORDER BY parameter_id),
                spname,
                STRING_AGG(pname, ', ')
            )
        FROM
        (
            SELECT TOP (100) PERCENT
                spname = FORMATMESSAGE('%s.%s', QUOTENAME(SCHEMA_NAME(r.schema_id)), QUOTENAME(r.name)),
                pname = p.name,
                pvalue = CASE WHEN p.name IS NOT NULL THEN FORMATMESSAGE(' %s %s', p.name, CASE WHEN p.system_type_id = 231 THEN 'NVARCHAR(MAX)' ELSE UPPER(TYPE_NAME(p.system_type_id )) END) ELSE '' END,
                p.parameter_id
            FROM sys.procedures r
            LEFT JOIN sys.parameters p
            ON p.object_id = r.object_id
            WHERE SCHEMA_NAME(r.schema_id) = 'tSQLt'
            AND r.name <> 'RunAll'
            ORDER BY r.name, p.parameter_id
        ) A
        GROUP BY spname
    ) B

    EXEC (@Command);

    SELECT @Command = STRING_AGG(CONVERT(NVARCHAR(MAX), command), CHAR(13))
    FROM
    (
        SELECT
            command = FORMATMESSAGE
            (
                'EXEC %s%s;',
                spname,
                STRING_AGG(pvalue, ',') WITHIN GROUP (ORDER BY parameter_id)
            )
        FROM
        (
            SELECT TOP (100) PERCENT
                spname = FORMATMESSAGE('%s.%s', QUOTENAME(SCHEMA_NAME(r.schema_id)), QUOTENAME(r.name)),
                pvalue = CASE WHEN p.name IS NOT NULL THEN FORMATMESSAGE(' %s = NULL', p.name) ELSE '' END,
                p.parameter_id
            FROM sys.procedures r
            LEFT JOIN sys.parameters p
            ON p.object_id = r.object_id
            WHERE SCHEMA_NAME(r.schema_id) = 'tSQLt'
            AND r.name NOT LIKE 'Internal%'
            AND r.name <> 'RunAll'
            ORDER BY r.name, p.parameter_id
        ) A
        GROUP BY spname
    ) B

    EXEC (@Command);
END;
GO