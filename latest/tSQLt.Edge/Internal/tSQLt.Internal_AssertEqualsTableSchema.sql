CREATE PROCEDURE tSQLt.Internal_AssertEqualsTableSchema
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    EXEC tSQLt.Private_ProcessTableName @Expected OUTPUT;
    EXEC tSQLt.Private_ProcessTableName @Actual OUTPUT;

    DECLARE @ExpectedColumns NVARCHAR(MAX);
    EXEC tSQLt.Private_GetColumns @ExpectedColumns OUTPUT, @Expected;
    DECLARE @ActualColumns NVARCHAR(MAX);
    EXEC tSQLt.Private_GetColumns @ActualColumns OUTPUT, @Actual;

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