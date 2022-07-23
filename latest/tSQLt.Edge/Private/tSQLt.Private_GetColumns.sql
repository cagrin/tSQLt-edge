CREATE PROCEDURE tSQLt.Private_GetColumns
    @Columns NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    SELECT
        @Columns = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                QUOTENAME(name),
                CASE is_computed
                    WHEN 1 THEN tSQLt.Private_GetComputedColumn(@ObjectName, column_id)
                    ELSE CONCAT_WS
                    (
                        ' ', tSQLt.Private_GetType(user_type_id, max_length, precision, scale, collation_name),
                        CASE is_identity WHEN 1 THEN tSQLt.Private_GetIdentityColumn(@ObjectName, column_id) END,
                        CASE WHEN default_object_id > 0 THEN tSQLt.Private_GetDefaultConstraints(@ObjectName, column_id) ELSE
                        CASE is_nullable WHEN 1 THEN 'NULL' ELSE 'NOT NULL' END END
                    )
                END
            ),
            ', '
        ) WITHIN GROUP (ORDER BY column_id)
    FROM tSQLt.System_Columns(@ObjectName)
END;
GO