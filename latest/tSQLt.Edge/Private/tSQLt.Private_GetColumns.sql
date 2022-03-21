CREATE FUNCTION tSQLt.Private_GetColumns (@TableName NVARCHAR(MAX))
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
                    QUOTENAME(name),
                    tSQLt.Private_GetType(user_type_id, max_length, precision, scale, collation_name),
                    CASE is_nullable WHEN 1 THEN 'NULL' ELSE 'NOT NULL' END
                ),
                ', '
            ) WITHIN GROUP (ORDER BY column_id)
        FROM
        (
            SELECT * FROM sys.columns
            WHERE object_id = OBJECT_ID(@TableName)
            UNION ALL
            SELECT * FROM tempdb.sys.columns
            WHERE object_id = OBJECT_ID(CONCAT('tempdb..', @TableName))
        ) A
    );
END;
GO