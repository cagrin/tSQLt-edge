CREATE PROCEDURE tSQLt.Internal_AssertNotEquals
    @Expected SQL_VARIANT,
    @Actual SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF NOT (@Expected = @Actual) OR NOT (@Expected IS NULL AND @Actual IS NULL)
    BEGIN
        RETURN 0;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT
        (
            'tSQLt.AssertNotEquals failed. Expected any value except:<',
            ISNULL(CONVERT(NVARCHAR(MAX), @Expected), '(null)'),
            '>. Actual:<',
            ISNULL(CONVERT(NVARCHAR(MAX), @Actual), '(null)'),
            '>.'
        );
        EXEC tSQLt.Fail @Message0 = @Failed, @Message1 = @Message;
    END
END;
GO