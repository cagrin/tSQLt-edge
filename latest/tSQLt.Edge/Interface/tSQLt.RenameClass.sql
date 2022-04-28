CREATE PROCEDURE tSQLt.RenameClass
    @SchemaName NVARCHAR(MAX),
    @NewSchemaName NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_RenameClass';
    EXEC @Command
    @SchemaName = @SchemaName,
    @NewSchemaName = @NewSchemaName;
END;
GO