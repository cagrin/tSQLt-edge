CREATE PROCEDURE tSQLt.Internal_ApplyIndex
    @TableName NVARCHAR(MAX),
    @IndexName NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.AssertObjectExists @TableName;

    DECLARE @ObjectName NVARCHAR(MAX);
    EXEC tSQLt.Private_GetQuotedObjectName @ObjectName OUTPUT, @TableName;

    DECLARE @FakeObjectName NVARCHAR(MAX);
    SELECT
        @FakeObjectName = FakeObjectName
    FROM tSQLt.Private_FakeTables
    WHERE ObjectName = @ObjectName

    DECLARE @System_IndexColumns tSQLt.System_IndexColumnsType
    INSERT INTO @System_IndexColumns
    EXEC tSQLt.System_IndexColumns @FakeObjectName

    DECLARE @IndexId INT;
    SELECT
        @IndexId = [object_id],
        @IndexName = QUOTENAME([index_name])
    FROM @System_IndexColumns
    WHERE @IndexName IN ([index_name], QUOTENAME([index_name]))

    IF @IndexId IS NOT NULL
    BEGIN
        DECLARE @IndexUnique NVARCHAR(MAX), @IndexType NVARCHAR(MAX), @IndexDefinition NVARCHAR(MAX);
        SELECT
            @IndexUnique = CASE WHEN [is_unique] = 1 THEN 'UNIQUE' END,
            @IndexType = [type_desc],
            @IndexDefinition = CONCAT
            (
                '(', STRING_AGG(QUOTENAME([column_name]), ', '), ')',
                CASE WHEN [has_filter] = 1 THEN CONCAT_WS(' ', 'WHERE', [filter_definition]) END
            )
        FROM @System_IndexColumns
        WHERE [object_id] = @IndexId
        GROUP BY [type_desc], [is_unique], [has_filter], [filter_definition]

        DECLARE @CreateIndex NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'DROP INDEX', @IndexName, 'ON', @FakeObjectName,
            'CREATE', @IndexUnique, @IndexType, 'INDEX', @IndexName, 'ON', @ObjectName, @IndexDefinition
        )

        EXEC sys.sp_executesql @CreateIndex;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.ApplyIndex failed.',
            CONCAT('Index:<', @IndexName, '> on table <', @TableName,'> does not exist.')
        );
        EXEC tSQLt.Fail @Failed;
    END
END;
GO