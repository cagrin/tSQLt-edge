CREATE PROCEDURE tSQLt.SpyProcedure
    @ProcedureName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL,
    @CallOriginal BIT = 0,
    @CatchExecutionTimes BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_SpyProcedure';
    EXEC @Command
    @ProcedureName = @ProcedureName,
    @CommandToExecute = @CommandToExecute,
    @CallOriginal = @CallOriginal,
    @CatchExecutionTimes = @CatchExecutionTimes;
END;
GO