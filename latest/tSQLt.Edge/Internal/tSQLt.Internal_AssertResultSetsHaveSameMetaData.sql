CREATE PROCEDURE tSQLt.Internal_AssertResultSetsHaveSameMetaData
    @ExpectedCommand NVARCHAR(MAX),
    @ActualCommand NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.AssertNotEqualsString NULL, @ExpectedCommand;
    EXEC tSQLt.AssertNotEqualsString NULL, @ActualCommand;

    DECLARE @ExpectedMetaData NVARCHAR(MAX); EXEC tSQLt.Private_GetMetaData @ExpectedCommand, @ExpectedMetaData OUTPUT;
    DECLARE @ActualMetaData NVARCHAR(MAX); EXEC tSQLt.Private_GetMetaData @ActualCommand, @ActualMetaData OUTPUT;

    IF (@ExpectedMetaData = @ActualMetaData)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.AssertResultSetsHaveSameMetaData failed.',
            CONCAT('Expected:<', ISNULL(@ExpectedMetaData, '(null)'), '>'),
            'has different metadata than',
            CONCAT('Actual:<', ISNULL(@ActualMetaData, '(null)'), '>.')
        );
        EXEC tSQLt.Fail @Message0 = @Failed;
    END
END;
GO