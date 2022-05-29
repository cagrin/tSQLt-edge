CREATE PROCEDURE tSQLt.Internal_AssertStringIn
    @Expected tSQLt.AssertStringTable READONLY,
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    EXEC tSQLt.Fail 'tSQLt.AssertStringIn is not yet supported.';
END;