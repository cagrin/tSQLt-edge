CREATE PROCEDURE tSQLt.Private_GetFakeColumns
    @FakeColumns NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX),
    @Identity BIT,
    @ComputedColumns BIT,
    @Defaults BIT,
    @NotNulls BIT
AS
BEGIN
    DECLARE @System_Columns tSQLt.System_ColumnsType;
    INSERT INTO @System_Columns
    EXEC tSQLt.System_Columns @ObjectName

    SELECT
        @FakeColumns = STRING_AGG
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
                        CASE WHEN @Defaults = 1 AND default_object_id > 0 THEN tSQLt.Private_GetDefaultConstraints(@ObjectName, column_id) ELSE
                        CASE WHEN @NotNulls = 1 AND is_nullable = 0 THEN 'NOT NULL' END END
                    )
                END
            ),
            ', '
        ) WITHIN GROUP (ORDER BY column_id)
    FROM @System_Columns
END;
GO