CREATE PROCEDURE tSQLt.Internal_AssertNotEqualsString
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF (@Expected <> @Actual) OR (@Expected IS NULL AND @Actual IS NOT NULL) OR (@Expected IS NOT NULL AND @Actual IS NULL)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.AssertNotEqualsString failed.',
            CONCAT('Expected any value except:<', ISNULL(@Expected, '(null)'), '>.')
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO