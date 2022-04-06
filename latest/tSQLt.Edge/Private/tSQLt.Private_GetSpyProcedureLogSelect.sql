CREATE FUNCTION tSQLt.Private_GetSpyProcedureLogSelect (@ObjectId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT
            STRING_AGG
            (
                CONCAT_WS
                (
                    ' ',
                    CASE
                        WHEN is_table_type = 1 THEN '(SELECT * FROM ' + name + ' FOR XML PATH(''row''),TYPE,ROOT('''+ REPLACE(name, '@', '')+'''))'
                        ELSE name
                    END,
                    CASE WHEN is_output = 1 THEN 'OUTPUT' ELSE NULL END
                ),
                ', '
            ) WITHIN GROUP (ORDER BY parameter_id)
        FROM
        (
            SELECT *, is_table_type = (SELECT is_table_type FROM tSQLt.System_Types(user_type_id))
            FROM tSQLt.System_Parameters(@ObjectId)
        ) P
    );
END;
GO