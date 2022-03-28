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
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.AssertEquals failed.',
            CONCAT('Expected:<', ISNULL(CONVERT(NVARCHAR(MAX), @Expected), '(null)'), '>.'),
            CONCAT('Actual:<', ISNULL(CONVERT(NVARCHAR(MAX), @Actual), '(null)'), '>.')
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO