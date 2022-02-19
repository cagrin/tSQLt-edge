CREATE PROCEDURE tSQLt.Internal_AssertEqualsTable
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL,
    @FailMsg NVARCHAR(MAX) = 'Unexpected/missing resultset rows!'
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.AssertEqualsTable', @Expected, @Actual, @Message, @FailMsg);
END;
GO