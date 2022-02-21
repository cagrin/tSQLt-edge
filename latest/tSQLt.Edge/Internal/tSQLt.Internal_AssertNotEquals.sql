CREATE PROCEDURE tSQLt.Internal_AssertNotEquals
    @Expected SQL_VARIANT,
    @Actual SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF (@Expected = @Actual) OR (@Expected IS NULL AND @Actual IS NULL)
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = FORMATMESSAGE(N'tSQLt.AssertNotEquals failed. Expected any value except:<%s>. Actual:<%s>.', CONVERT(NVARCHAR(MAX), @Expected), CONVERT(NVARCHAR(MAX), @Actual));
        EXEC tSQLt.Fail @Message0 = @Failed, @Message1 = @Message;
    END
    ELSE
    BEGIN
        RETURN 0;
    END
END;
GO