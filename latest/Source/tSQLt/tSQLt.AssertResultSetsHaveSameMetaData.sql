CREATE PROCEDURE tSQLt.AssertResultSetsHaveSameMetaData
    @expectedCommand NVARCHAR(MAX),
    @actualCommand NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertResultSetsHaveSameMetaData';
    EXEC @Command
    @expectedCommand = @expectedCommand,
    @actualCommand = @actualCommand;
END;
GO