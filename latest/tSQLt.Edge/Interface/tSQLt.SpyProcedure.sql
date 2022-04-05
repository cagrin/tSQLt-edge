CREATE PROCEDURE tSQLt.SpyProcedure
    @ProcedureName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL,
    @CallOriginal BIT = 0
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_SpyProcedure';
    EXEC @Command
    @ProcedureName = @ProcedureName,
    @CommandToExecute = @CommandToExecute,
    @CallOriginal = @CallOriginal;
END;
GO