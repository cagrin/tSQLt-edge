CREATE PROCEDURE tSQLt.AssertNotEquals
    @Expected SQL_VARIANT,
    @Actual SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT '- tSQLt.AssertNotEquals';
END;
GO