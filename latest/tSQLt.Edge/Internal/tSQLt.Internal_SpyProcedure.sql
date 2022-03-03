CREATE PROCEDURE tSQLt.Internal_SpyProcedure
    @ProcedureName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @ObjectId INT = OBJECT_ID(@ProcedureName);

    DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE PROCEDURE',
        @ProcedureName,
        tSQLt.Private_GetParametersWithTypes (@Objectid),
        'AS BEGIN',
        @CommandToExecute,
        'RETURN; END;'
    );

    EXEC tSQLt.Private_RenameObject @ObjectId;

    EXEC (@Command);
END;
GO