CREATE PROCEDURE tSQLt.Internal_FakeTable
    @TableName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL,
    @Identity BIT = NULL,
    @ComputedColumns BIT = NULL,
    @Defaults BIT = NULL,
    @NotNulls BIT = NULL
AS
BEGIN
    EXEC tSQLt.Private_ProcessTableName @TableName OUTPUT, @SchemaName;

    DECLARE @FakeColumns NVARCHAR(MAX);
    EXEC tSQLt.Private_GetFakeColumns @FakeColumns OUTPUT, @TableName, @Identity, @ComputedColumns, @Defaults, @NotNulls;

    DECLARE @CreateFakeTableCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE TABLE', @TableName, CONCAT('(', @FakeColumns, ');')
    );

    DECLARE @ObjectId INT = OBJECT_ID(@TableName);
    EXEC tSQLt.Private_RenameObject @TableName;
    EXEC (@CreateFakeTableCommand);

    INSERT INTO tSQLt.Private_FakeTables (ObjectId, FakeObjectId)
    VALUES (@ObjectId, OBJECT_ID(@TableName));
END;
GO