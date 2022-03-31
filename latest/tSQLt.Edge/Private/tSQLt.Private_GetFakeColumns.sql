CREATE FUNCTION tSQLt.Private_GetFakeColumns (@ObjectName NVARCHAR(MAX), @Identity BIT, @ComputedColumns BIT, @Defaults BIT)
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
                    CASE
                        WHEN @ComputedColumns = 1 AND is_computed = 1 THEN tSQLt.Private_GetComputedColumn(@ObjectName, column_id)
                        ELSE CONCAT_WS
                        (
                            ' ', tSQLt.Private_GetType(user_type_id, max_length, precision, scale, collation_name),
                            CASE WHEN @Identity = 1 AND is_identity = 1 THEN tSQLt.Private_GetIdentityColumn(@ObjectName, column_id) END,
                            CASE WHEN @Defaults = 1 AND default_object_id > 0 THEN tSQLt.Private_GetDefaultConstraints(@ObjectName, column_id) END
                        )
                    END
                ),
                ', '
            ) WITHIN GROUP (ORDER BY column_id)
        FROM tSQLt.System_Columns(@ObjectName)
    );
END;
GO