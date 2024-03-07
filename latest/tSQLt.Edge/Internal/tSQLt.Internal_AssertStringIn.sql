CREATE PROCEDURE tSQLt.Internal_AssertStringIn
    @Expected tSQLt.AssertStringTable READONLY,
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF EXISTS
    (
        SELECT 1 FROM @Expected
        WHERE ([value] IS NOT NULL AND ISNULL([value], '') = @Actual)
        OR ([value] IS NULL AND @Actual IS NULL)
    )
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @ExpectedStringAgg NVARCHAR(MAX) =
        (
            SELECT
                STRING_AGG
                (
                    [value],
                    ', '
                ) WITHIN GROUP (ORDER BY [value])
            FROM @Expected
        );

        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.AssertStringIn failed.',
            CONCAT('String:<', ISNULL(@Actual, '(null)'), '>'),
            'is not in',
            CONCAT('<', ISNULL(@ExpectedStringAgg, '(null)'), '>.')
        );

        EXEC tSQLt.Fail @Message, @Failed;
    END
END;