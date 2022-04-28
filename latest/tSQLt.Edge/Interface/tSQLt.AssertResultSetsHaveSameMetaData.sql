CREATE PROCEDURE tSQLt.AssertResultSetsHaveSameMetaData
    @expectedCommand NVARCHAR(MAX),
    @actualCommand NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_AssertResultSetsHaveSameMetaData';
    EXEC @Command
    @expectedCommand = @expectedCommand,
    @actualCommand = @actualCommand;
END;
GO