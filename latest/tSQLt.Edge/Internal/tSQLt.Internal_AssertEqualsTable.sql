CREATE PROCEDURE tSQLt.Internal_AssertEqualsTable
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL,
    @FailMsg NVARCHAR(MAX) = 'Unexpected/missing resultset rows!'
AS
BEGIN
    DECLARE @Diffs INT = 0;
    EXEC tSQLt.Private_CompareTables @Expected, @Actual, @Diffs OUTPUT;

    IF @Diffs > 0
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT
        (
            'tSQLt.AssertEqualsTable failed. Expected:<',
            @Expected,
            '> has different rowset than Actual:<',
            @Actual,
            '>.'
        );
        EXEC tSQLt.Fail @Message0 = @Failed;
    END
END;
GO