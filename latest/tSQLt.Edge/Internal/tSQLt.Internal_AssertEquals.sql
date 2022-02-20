CREATE PROCEDURE tSQLt.Internal_AssertEquals
    @Expected SQL_VARIANT,
    @Actual SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.AssertEquals', '@Expected', '@Actual', '@Message');
END;
GO