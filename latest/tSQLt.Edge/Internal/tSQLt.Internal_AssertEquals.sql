CREATE PROCEDURE tSQLt.Internal_AssertEquals
    @Expected SQL_VARIANT,
    @Actual SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF (@Expected = @Actual) OR (@Expected IS NULL AND @Actual IS NULL)
    BEGIN
        RETURN 0;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = FORMATMESSAGE(N'tSQLt.AssertEquals failed. Expected:<%s>. Actual:<%s>.', CONVERT(NVARCHAR(MAX), @Expected), CONVERT(NVARCHAR(MAX), @Actual));
        EXEC tSQLt.Fail @Message0 = @Failed, @Message1 = @Message;
    END
END;
GO