CREATE PROCEDURE tSQLt.Internal_AssertEquals
    @Expected SQL_VARIANT,
    @Actual SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF (@Expected = @Actual) OR (@Expected IS NULL AND @Actual IS NULL)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT
        (
            'tSQLt.AssertEquals failed. Expected:<',
            ISNULL(CONVERT(NVARCHAR(MAX), @Expected), '(null)'),
            '>. Actual:<',
            ISNULL(CONVERT(NVARCHAR(MAX), @Actual), '(null)'),
            '>.'
        );
        EXEC tSQLt.Fail @Message0 = @Failed, @Message1 = @Message;
    END
END;
GO