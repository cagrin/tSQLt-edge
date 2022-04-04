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
                    CAST('' AS NVARCHAR(MAX)),
                    'EXEC tSQLt.Private_Run @TestName = ''',
                    REPLACE(TestName, '''', ''''''),
                    ''';'
                ),
                NCHAR(10)
            )
            WITHIN GROUP (ORDER BY TestName)
        FROM tSQLt.Private_FindTestNames(@TestName)
    );

    DELETE FROM tSQLt.TestResult;

    EXEC (@Command);

    IF OBJECT_ID(@TestName) IS NOT NULL
        INSERT INTO tSQLt.TestResult (Class, TestCase, Result) VALUES (OBJECT_SCHEMA_NAME(OBJECT_ID(@TestName)), OBJECT_NAME(OBJECT_ID(@TestName)), 'Success');
END;
GO