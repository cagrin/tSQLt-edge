CREATE PROCEDURE tSQLt.Private_ApplyForeignKey
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT,
    @NoCascade BIT
AS
BEGIN
    DECLARE @ParentName NVARCHAR(MAX), @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX), @CreateUniqueIndex NVARCHAR(MAX);
    SELECT
        @ParentName = CONCAT(QUOTENAME(SCHEMA_NAME(fk.schema_id)), '.', QUOTENAME(OBJECT_NAME(fk.parent_object_id))),
        @ConstraintName = QUOTENAME(fk.name),
        @ConstraintDefinition = CONCAT
        (
            '(', fk.foreign_key_columns, ')',
            ' REFERENCES ', QUOTENAME(SCHEMA_NAME(fk.referenced_schema_id)), '.', QUOTENAME(ISNULL(OBJECT_NAME(ftl.fake_object_id), fk.referenced_name)),
            ' (', fk.referenced_columns, ')',
            CASE WHEN @NoCascade = 1 THEN ''
            ELSE CONCAT
            (
                ' ON UPDATE ', REPLACE(fk.update_referential_action_desc, '_', ' '),
                ' ON DELETE ', REPLACE(fk.delete_referential_action_desc, '_', ' ')
            )
            END
        ),
        @CreateUniqueIndex = CASE WHEN ftl.fake_object_id IS NOT NULL THEN CONCAT
        (
            'CREATE UNIQUE INDEX ', QUOTENAME(CAST(NEWID() AS NVARCHAR(MAX))),
            ' ON ', QUOTENAME(SCHEMA_NAME(fk.referenced_schema_id)), '.', QUOTENAME(ISNULL(OBJECT_NAME(ftl.fake_object_id), fk.referenced_name)),
            ' (', fk.referenced_columns, ')'
        ) END
    FROM tSQLt.System_ForeignKeys() fk
    LEFT JOIN tSQLt.Private_FakeTableLog ftl ON fk.referenced_object_id = ftl.object_id
    WHERE fk.schema_id = SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName)))
    AND fk.name = OBJECT_NAME(@ConstraintId)

    DECLARE @CreateForeignKey NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'FOREIGN KEY', @ConstraintDefinition
    )

    EXEC (@CreateUniqueIndex);
    EXEC (@CreateForeignKey);
END;
GO