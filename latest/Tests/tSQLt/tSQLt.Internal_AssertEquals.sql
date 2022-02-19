CREATE PROCEDURE tSQLt.Internal_AssertEquals
    @Expected SQL_VARIANT,
    @Actual SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT '- tSQLt.AssertEquals';
END;
GO