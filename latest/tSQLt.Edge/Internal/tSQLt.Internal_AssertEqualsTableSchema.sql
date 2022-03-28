CREATE PROCEDURE tSQLt.Internal_AssertEqualsTableSchema
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    EXEC tSQLt.AssertObjectExists @Expected;
    EXEC tSQLt.AssertObjectExists @Actual;

    DECLARE @ExpectedColumns NVARCHAR(MAX) = tSQLt.Private_GetColumns (@Expected);
    DECLARE @ActualColumns NVARCHAR(MAX) = tSQLt.Private_GetColumns (@Actual);

    IF (@ExpectedColumns = @ActualColumns)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.AssertEqualsTableSchema failed.',
            CONCAT('Expected:<', ISNULL(@ExpectedColumns, '(null)'), '>.'),
            CONCAT('Actual:<', ISNULL(@ActualColumns, '(null)'), '>.')
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO