CREATE PROCEDURE tSQLt.Internal_ApplyIndex
    @TableName NVARCHAR(MAX),
    @IndexName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @ObjectName NVARCHAR(MAX) = CONCAT(QUOTENAME(OBJECT_SCHEMA_NAME(OBJECT_ID(@TableName))), '.', QUOTENAME(OBJECT_NAME(OBJECT_ID(@TableName))));

    EXEC tSQLt.AssertObjectExists @ObjectName;

    DECLARE @System_IndexColumns tSQLt.System_IndexColumnsType
    INSERT INTO @System_IndexColumns
    EXEC tSQLt.System_IndexColumns

    DECLARE @ObjectId INT, @ParentName NVARCHAR(MAX);
    SELECT
        @ObjectId = [object_id],
        @IndexName = QUOTENAME([index_name]),
        @ParentName = CONCAT(QUOTENAME(SCHEMA_NAME([schema_id])), '.', QUOTENAME([table_name]))
    FROM @System_IndexColumns
    WHERE [schema_id] = SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName))) --todo
    AND ([index_name] = @IndexName OR QUOTENAME([index_name]) = @IndexName)

    IF @ObjectId IS NOT NULL
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
        WHERE [object_id] = @ObjectId
        GROUP BY [type_desc], [is_unique], [has_filter], [filter_definition]

        DECLARE @CreateIndex NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'DROP INDEX', @IndexName, 'ON', @ParentName,
            'CREATE', @IndexUnique, @IndexType, 'INDEX', @IndexName, 'ON', @ObjectName, @IndexDefinition
        )

        EXEC (@CreateIndex);
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