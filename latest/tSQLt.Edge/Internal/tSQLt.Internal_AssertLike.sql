CREATE PROCEDURE tSQLt.Internal_AssertLike
    @ExpectedPattern NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF LEN(@ExpectedPattern) > 4000
        EXEC tSQLt.Fail '@ExpectedPattern may not exceed 4000 characters.';

    IF (@Actual LIKE @ExpectedPattern) OR (@Actual IS NULL AND @ExpectedPattern IS NULL)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.AssertLike failed.',
            CONCAT('ExpectedPattern:<', ISNULL(CONVERT(NVARCHAR(MAX), @ExpectedPattern), '(null)'), '>'),
            'but',
            CONCAT('Actual:<', ISNULL(CONVERT(NVARCHAR(MAX), @Actual), '(null)'), '>.')
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO