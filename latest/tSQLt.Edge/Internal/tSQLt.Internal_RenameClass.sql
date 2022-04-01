CREATE PROCEDURE tSQLt.Internal_RenameClass
    @SchemaName NVARCHAR(MAX),
    @NewSchemaName NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.Fail 'tSQLt.RenameClass is not supported.';
END;
GO