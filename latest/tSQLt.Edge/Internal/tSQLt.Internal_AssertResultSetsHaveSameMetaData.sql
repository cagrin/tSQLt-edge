CREATE PROCEDURE tSQLt.Internal_AssertResultSetsHaveSameMetaData
    @ExpectedCommand NVARCHAR(MAX),
    @ActualCommand NVARCHAR(MAX)
AS
BEGIN
    DECLARE @ExpectedMetaData NVARCHAR(MAX); EXEC tSQLt.Private_GetMetaData @ExpectedCommand, @ExpectedMetaData OUTPUT;

    DECLARE @ActualMetaData NVARCHAR(MAX); EXEC tSQLt.Private_GetMetaData @ActualCommand, @ActualMetaData OUTPUT;

    IF (@ExpectedMetaData = @ActualMetaData)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT
        (
            'tSQLt.AssertResultSetsHaveSameMetaData failed. Expected:<',
            @ExpectedMetaData,
            '> has different metadata than Actual:<',
            @ActualMetaData,
            '>.'
        );
        EXEC tSQLt.Fail @Message0 = @Failed;
    END
END;
GO