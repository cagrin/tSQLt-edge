CREATE PROCEDURE tSQLt.Internal_AssertEqualsString
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF (@Expected = @Actual) OR (@Expected IS NULL AND @Actual IS NULL)
    BEGIN
        RETURN 0;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = FORMATMESSAGE(N'tSQLt.AssertEqualsString failed. Expected:<%s>. Actual:<%s>.', @Expected, @Actual);
        EXEC tSQLt.Fail @Message0 = @Failed, @Message1 = @Message;
    END
END;
GO