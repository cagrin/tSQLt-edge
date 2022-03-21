CREATE PROCEDURE tSQLt.Internal_AssertEqualsTableSchema
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @ExpectedColumns NVARCHAR(MAX) = tSQLt.Private_GetColumns (@Expected);

    DECLARE @ActualColumns NVARCHAR(MAX) = tSQLt.Private_GetColumns (@Actual);

    IF (@ExpectedColumns = @ActualColumns)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT
        (
            'tSQLt.AssertEqualsTableSchema failed. Expected:<',
            ISNULL(@ExpectedColumns, '(null)'),
            '>. Actual:<',
            ISNULL(@ActualColumns, '(null)'),
            '>.'
        );
        EXEC tSQLt.Fail @Message0 = @Failed;
    END
END;
GO