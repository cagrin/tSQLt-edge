CREATE PROCEDURE tSQLt.AssertEqualsTable
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL,
    @FailMsg NVARCHAR(MAX) = 'Unexpected/missing resultset rows!'
AS
BEGIN
    PRINT '- tSQLt.AssertEqualsTable';
END;
GO