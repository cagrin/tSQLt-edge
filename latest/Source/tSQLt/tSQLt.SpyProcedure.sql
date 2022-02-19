CREATE PROCEDURE tSQLt.SpyProcedure
    @ProcedureName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_SpyProcedure';
    EXEC @Command
    @ProcedureName = @ProcedureName,
    @CommandToExecute = @CommandToExecute;
END;
GO