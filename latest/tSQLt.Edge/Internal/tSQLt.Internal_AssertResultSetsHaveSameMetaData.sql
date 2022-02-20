CREATE PROCEDURE tSQLt.Internal_AssertResultSetsHaveSameMetaData
    @expectedCommand NVARCHAR(MAX),
    @actualCommand NVARCHAR(MAX)
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.AssertResultSetsHaveSameMetaData', @expectedCommand, @actualCommand);
END;
GO