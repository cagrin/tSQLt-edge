CREATE FUNCTION tSQLt.Private_GetColumns (@ObjectId INT)
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
        FROM sys.columns
        WHERE object_id = @ObjectId
    );
END;
GO