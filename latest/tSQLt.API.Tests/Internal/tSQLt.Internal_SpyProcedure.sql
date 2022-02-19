CREATE PROCEDURE tSQLt.Internal_SpyProcedure
    @ProcedureName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.SpyProcedure', @ProcedureName, @CommandToExecute);
END;
GO