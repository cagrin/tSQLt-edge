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
                    tSQLt.Private_GetType(user_type_id, max_length, precision, scale, collation_name),
                    CASE
                        WHEN @Identity = 1 and is_identity = 1 THEN tSQLt.Private_GetIdentityColumn(@ObjectName, column_id)
                        ELSE NULL
                    END
                ),
                ', '
            ) WITHIN GROUP (ORDER BY column_id)
        FROM tSQLt.System_Columns(@ObjectName)
    );
END;
GO