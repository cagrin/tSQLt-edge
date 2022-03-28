CREATE PROCEDURE tSQLt.Internal_AssertEqualsString
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
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
            'tSQLt.AssertEqualsString failed.',
            CONCAT('Expected:<', ISNULL(@Expected, '(null)'), '>.'),
            CONCAT('Actual:<', ISNULL(@Actual, '(null)'), '>.')
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO