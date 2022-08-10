CREATE PROCEDURE tSQLt.Private_ApplyPrimaryKey
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT
AS
BEGIN
    DECLARE @System_IndexColumns tSQLt.System_IndexColumnsType
    INSERT INTO @System_IndexColumns
    EXEC tSQLt.System_IndexColumns

    DECLARE @ParentName NVARCHAR(MAX), @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX), @AlterPrimaryColumns NVARCHAR(MAX);
    SELECT
        @ParentName = CONCAT(QUOTENAME(SCHEMA_NAME([schema_id])), '.', QUOTENAME([table_name])),
        @ConstraintName = QUOTENAME([index_name]),
        @ConstraintDefinition = CONCAT
        (
            [type_desc],
            ' (',
            STRING_AGG
            (
                CONCAT_WS
                (
                    ' ',
                    QUOTENAME([column_name]),
                    CASE WHEN [is_descending_key] = 1 THEN 'DESC' ELSE 'ASC' END
                ),
                ', '
            ),
            ')'
        ),
        @AlterPrimaryColumns = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                'ALTER TABLE', @ObjectName, 'ALTER COLUMN', QUOTENAME([column_name]),
                tSQLt.Private_GetType([user_type_id], [max_length], [precision], [scale], [collation_name]),
                'NOT NULL'
            ),
            ' '
        )
    FROM @System_IndexColumns
    WHERE [schema_id] = SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName)))
    AND [index_name] = OBJECT_NAME(@ConstraintId)
    AND [is_primary_key] = 1
    GROUP BY [schema_id], [table_name], [index_name], [type_desc]

    DECLARE @CreatePrimaryKey NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'PRIMARY KEY', @ConstraintDefinition
    )

    EXEC (@AlterPrimaryColumns);
    EXEC (@CreatePrimaryKey);
END;
GO