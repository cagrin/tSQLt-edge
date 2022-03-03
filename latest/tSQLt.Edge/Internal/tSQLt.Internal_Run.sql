CREATE PROCEDURE tSQLt.Internal_Run
    @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) =
    (
        SELECT
            STRING_AGG
            (
                CONCAT
                (
                    'EXEC tSQLt.Private_Run @TestName = ''',
                    QUOTENAME(SCHEMA_NAME(r.schema_id)),
                    '.',
                    QUOTENAME(r.name),
                    ''';'
                ),
                NCHAR(10)
            )
            WITHIN GROUP (ORDER BY SCHEMA_NAME(r.schema_id), r.name)
        FROM sys.procedures r
        WHERE r.name LIKE 'test%'
        AND SCHEMA_NAME(r.schema_id) <> 'tSQLt'
        AND NOT EXISTS (SELECT 1 FROM sys.parameters p WHERE p.object_id = r.object_id)
        AND
        (
            @TestName IS NULL
            OR @TestName = QUOTENAME(SCHEMA_NAME(r.schema_id))
            OR @Testname = CONCAT(QUOTENAME(SCHEMA_NAME(r.schema_id)), '.', QUOTENAME(r.name))
        )
    );

    EXEC (@Command);
END;
GO