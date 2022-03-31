CREATE PROCEDURE tSQLt.Internal_AssertEqualsTable
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL,
    @FailMsg NVARCHAR(MAX) = 'Unexpected/missing resultset rows!'
AS
BEGIN
    EXEC tSQLt.Private_ProcessTableName @Expected OUTPUT;
    EXEC tSQLt.Private_ProcessTableName @Actual OUTPUT;

    DECLARE @Diffs INT = 0;
    EXEC tSQLt.Private_CompareTables @Expected, @Actual, @Diffs OUTPUT;

    IF @Diffs > 0
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.AssertEqualsTable failed.',
            CONCAT('Expected:<', ISNULL(@Expected, '(null)'), '>'),
            'has different rowset than',
            CONCAT('Actual:<', ISNULL(@Actual, '(null)'), '>.')
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO