CREATE PROCEDURE tSQLt.Internal_AssertNotEquals
    @Expected SQL_VARIANT,
    @Actual SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.AssertNotEquals', '@Expected', '@Actual', @Message);
END;
GO