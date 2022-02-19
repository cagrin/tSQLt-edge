CREATE PROCEDURE tSQLt.Internal_AssertLike
    @ExpectedPattern NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.AssertLike', @ExpectedPattern, @Actual, @Message);
END;
GO