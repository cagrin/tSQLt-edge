CREATE PROCEDURE tSQLt.Internal_AssertLike
    @ExpectedPattern NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF (@Actual LIKE @ExpectedPattern) OR (@Actual IS NULL AND @ExpectedPattern IS NULL)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT
        (
            'tSQLt.AssertLike failed. ExpectedPattern:<',
            ISNULL(CONVERT(NVARCHAR(MAX), @ExpectedPattern), '(null)'),
            '> but Actual:<',
            ISNULL(CONVERT(NVARCHAR(MAX), @Actual), '(null)'),
            '>.'
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO