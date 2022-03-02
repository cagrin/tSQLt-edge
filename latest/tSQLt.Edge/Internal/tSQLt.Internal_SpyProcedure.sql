CREATE PROCEDURE tSQLt.Internal_SpyProcedure
    @ProcedureName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @ObjectId INT = OBJECT_ID(@ProcedureName);

    DECLARE @Command NVARCHAR(MAX) = FORMATMESSAGE
    (
        'CREATE PROCEDURE %s %s AS BEGIN %s RETURN; END;',
        @ProcedureName,
        tSQLt.Private_GetParametersWithTypes (@Objectid),
        ISNULL(@CommandToExecute + ';', '')
    );

    EXEC tSQLt.Private_RenameObject @ObjectId;

    EXEC (@Command);
END;
GO