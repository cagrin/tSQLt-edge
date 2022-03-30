CREATE PROCEDURE tSQLt.Internal_FakeTable
    @TableName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL, --parameter preserved for backward compatibility. Do not use. Will be removed soon.
    @Identity BIT = NULL,
    @ComputedColumns BIT = NULL,
    @Defaults BIT = NULL
AS
BEGIN
    EXEC tSQLt.AssertObjectExists @TableName;

    DECLARE @ObjectId INT = OBJECT_ID(@TableName);
    DECLARE @Columns NVARCHAR(MAX) = tSQLt.Private_GetColumns (@TableName);

    DECLARE @CreateFakeTableCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE TABLE', @TableName, CONCAT('(', REPLACE(@Columns, 'NOT NULL', 'NULL'), ');')
    );

    EXEC tSQLt.Private_RenameObject @ObjectId;
    EXEC (@CreateFakeTableCommand);
END;
GO