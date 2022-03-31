CREATE PROCEDURE tSQLt.Internal_FakeTable
    @TableName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL,
    @Identity BIT = NULL,
    @ComputedColumns BIT = NULL,
    @Defaults BIT = NULL
AS
BEGIN
    IF @SchemaName IS NOT NULL
        EXEC tSQLt.Fail '@SchemaName parameter preserved for backward compatibility. Do not use. Will be removed soon.';

    EXEC tSQLt.Private_ProcessTableName @TableName OUTPUT;

    DECLARE @FakeColumns NVARCHAR(MAX) = tSQLt.Private_GetFakeColumns (@TableName, @Identity, @ComputedColumns, @Defaults);

    DECLARE @CreateFakeTableCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'CREATE TABLE', @TableName, CONCAT('(', @FakeColumns, ');')
    );

    EXEC tSQLt.Private_RenameObject @TableName;
    EXEC (@CreateFakeTableCommand);
END;
GO