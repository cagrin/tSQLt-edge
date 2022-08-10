CREATE PROCEDURE tSQLt.Private_ApplyUniqueConstraint
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT
AS
BEGIN
    DECLARE @System_IndexColumns tSQLt.System_IndexColumnsType
    INSERT INTO @System_IndexColumns
    EXEC tSQLt.System_IndexColumns

    DECLARE @ParentName NVARCHAR(MAX), @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX);
    SELECT
        @ParentName = CONCAT(QUOTENAME(SCHEMA_NAME([schema_id])), '.', QUOTENAME([table_name])),
        @ConstraintName = QUOTENAME([index_name]),
        @ConstraintDefinition = CONCAT
        (
            '(',
            STRING_AGG
            (
                QUOTENAME([column_name]),
                ', '
            ),
            ')'
        )
    FROM @System_IndexColumns
    WHERE [schema_id] = SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName)))
    AND [index_name] = OBJECT_NAME(@ConstraintId)
    AND [is_unique_constraint] = 1
    GROUP BY [schema_id], [table_name], [index_name], [type_desc]

    DECLARE @CreateUniqueConstraint NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'UNIQUE', @ConstraintDefinition
    )

    EXEC (@CreateUniqueConstraint);
END;
GO