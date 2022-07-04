CREATE PROCEDURE tSQLt.Internal_ApplyConstraint
    @TableName NVARCHAR(MAX),
    @ConstraintName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL, --parameter preserved for backward compatibility. Do not use. Will be removed soon.
    @NoCascade BIT = 0
AS
BEGIN
    DECLARE @ObjectName NVARCHAR(MAX) = @TableName;

    IF @SchemaName IS NOT NULL
        SET @ObjectName = CONCAT(@SchemaName, '.', @TableName)

    EXEC tSQLt.AssertObjectExists @ObjectName;

    DECLARE @ConstraintId INT, @ConstraintType CHAR(2);
    SELECT
        @ConstraintId = [object_id],
        @ConstraintType = [type]
    FROM tSQLt.System_objects()
    WHERE [schema_id] = SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName)))
    AND ([name] = @ConstraintName OR QUOTENAME([name]) = @ConstraintName)

    IF @ConstraintType = 'C'
    BEGIN
        EXEC tSQLt.Internal_ApplyCheckConstraint @Objectname, @ConstraintId;
    END
    ELSE IF @ConstraintType = 'PK'
    BEGIN
        EXEC tSQLt.Internal_ApplyPrimaryKey @Objectname, @ConstraintId;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.ApplyConstraint failed.',
            CONCAT('Constraint:<', @ConstraintName, '> on table <', @ObjectName,'> does not exist.')
        );
        EXEC tSQLt.Fail @Failed;
    END
END;
GO

CREATE PROCEDURE tSQLt.Internal_ApplyCheckConstraint
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT
AS
BEGIN
    DECLARE @ParentName NVARCHAR(MAX), @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX);
    SELECT
        @ParentName = CONCAT(QUOTENAME(SCHEMA_NAME([schema_id])), '.', QUOTENAME(OBJECT_NAME([parent_object_id]))),
        @ConstraintName = QUOTENAME(OBJECT_NAME([object_id])),
        @ConstraintDefinition = [definition]
    FROM tSQLt.System_CheckConstraints()
    WHERE [object_id] = @ConstraintId

    DECLARE @CreateConstraint NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'CHECK', @ConstraintDefinition
    )

    EXEC (@CreateConstraint);
END;
GO

CREATE PROCEDURE tSQLt.Internal_ApplyPrimaryKey
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT
AS
BEGIN
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
    FROM tSQLt.System_PrimaryKeyColumns()
    WHERE [schema_id] = SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName)))
    AND [index_name] = OBJECT_NAME(@ConstraintId)
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
