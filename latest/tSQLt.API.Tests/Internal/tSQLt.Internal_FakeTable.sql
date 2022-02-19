CREATE PROCEDURE tSQLt.Internal_FakeTable
    @TableName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL, --parameter preserved for backward compatibility. Do not use. Will be removed soon.
    @Identity BIT = NULL,
    @ComputedColumns BIT = NULL,
    @Defaults BIT = NULL
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.FakeTable', @TableName, @SchemaName, '@Identity', '@ComputedColumns', '@Defaults');
END;
GO