CREATE FUNCTION tSQLt.Private_GetColumnsNames (@TableName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT
            STRING_AGG
            (
                QUOTENAME(name),
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