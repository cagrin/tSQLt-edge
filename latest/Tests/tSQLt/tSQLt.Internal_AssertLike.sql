CREATE PROCEDURE tSQLt.Internal_AssertLike
    @ExpectedPattern NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT '- tSQLt.AssertLike';
END;
GO