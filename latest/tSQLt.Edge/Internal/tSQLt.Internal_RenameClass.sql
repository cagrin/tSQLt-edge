CREATE PROCEDURE tSQLt.Internal_RenameClass
    @SchemaName NVARCHAR(MAX),
    @NewSchemaName NVARCHAR(MAX)
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.RenameClass', @SchemaName, @NewSchemaName);
END;
GO