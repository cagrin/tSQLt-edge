CREATE PROCEDURE tSQLt.Private_ApplyForeignKey
    @ParentName NVARCHAR(MAX),
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT,
    @NoCascade BIT
AS
BEGIN
    DECLARE @System_ForeignKeys tSQLt.System_ForeignKeysType
    INSERT INTO @System_ForeignKeys
    EXEC tSQLt.System_ForeignKeys @ObjectName, @ConstraintId

    DECLARE @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX), @CreateUniqueIndex NVARCHAR(MAX);
    SELECT
        @ConstraintName = QUOTENAME(fk.name),
        @ConstraintDefinition = CONCAT
        (
            '(', fk.foreign_key_columns, ')',
            ' REFERENCES ', QUOTENAME(fk.referenced_schema_name), '.', QUOTENAME(ISNULL(OBJECT_NAME(ft.FakeObjectId), fk.referenced_name)),
            ' (', fk.referenced_columns, ')',
            CASE WHEN @NoCascade = 1 THEN ''
            ELSE CONCAT
            (
                ' ON UPDATE ', REPLACE(fk.update_referential_action_desc, '_', ' '),
                ' ON DELETE ', REPLACE(fk.delete_referential_action_desc, '_', ' ')
            )
            END
        ),
        @CreateUniqueIndex = CASE WHEN ft.FakeObjectId IS NOT NULL THEN CONCAT
        (
            'CREATE UNIQUE INDEX ', QUOTENAME(CAST(NEWID() AS NVARCHAR(MAX))),
            ' ON ', QUOTENAME(fk.referenced_schema_name), '.', QUOTENAME(ISNULL(OBJECT_NAME(ft.FakeObjectId), fk.referenced_name)),
            ' (', fk.referenced_columns, ')'
        ) END
    FROM @System_ForeignKeys fk
    LEFT JOIN tSQLt.Private_FakeTables ft ON fk.referenced_object_id = ft.ObjectId

    DECLARE @CreateForeignKey NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'FOREIGN KEY', @ConstraintDefinition
    )

    EXEC sys.sp_executesql @CreateUniqueIndex;
    EXEC sys.sp_executesql @CreateForeignKey;
END;
GO