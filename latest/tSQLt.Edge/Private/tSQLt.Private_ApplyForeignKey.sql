CREATE PROCEDURE tSQLt.Private_ApplyForeignKey
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT,
    @NoCascade BIT
AS
BEGIN
    DECLARE @ParentName NVARCHAR(MAX), @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX), @CreateUniqueIndex NVARCHAR(MAX);
    SELECT
        @ParentName = CONCAT(QUOTENAME(SCHEMA_NAME(fk.[schema_id])), '.', QUOTENAME(OBJECT_NAME(fk.[parent_object_id]))),
        @ConstraintName = QUOTENAME(fk.[name]),
        @ConstraintDefinition = CONCAT
        (
            '(',
            (
                SELECT STRING_AGG(QUOTENAME(pci.name), ', ')
                FROM sys.foreign_key_columns c
                INNER JOIN sys.columns pci
                ON pci.object_id = c.parent_object_id
                AND pci.column_id = c.parent_column_id
                WHERE fk.object_id = c.constraint_object_id
            ),
            ') REFERENCES ',
            QUOTENAME(SCHEMA_NAME(t.schema_id)), '.', QUOTENAME(ISNULL(OBJECT_NAME(ftl.fake_object_id), t.name)),
            ' (',
            (
                SELECT STRING_AGG(QUOTENAME(rci.name), ', ')
                FROM sys.foreign_key_columns c
                INNER JOIN sys.columns rci
                ON rci.object_id = c.referenced_object_id
                AND rci.column_id = c.referenced_column_id
                WHERE fk.object_id = c.constraint_object_id
            ),
            ')'
        ),
        @CreateUniqueIndex = CASE WHEN ftl.fake_object_id IS NOT NULL THEN CONCAT
        (
            'CREATE UNIQUE INDEX ', QUOTENAME(CAST(NEWID() AS NVARCHAR(MAX))),
            ' ON ', QUOTENAME(SCHEMA_NAME(t.schema_id)), '.', QUOTENAME(ISNULL(OBJECT_NAME(ftl.fake_object_id), t.name)),
            ' (',
            (
                SELECT STRING_AGG(QUOTENAME(rci.name), ', ')
                FROM sys.foreign_key_columns c
                INNER JOIN sys.columns rci
                ON rci.object_id = c.referenced_object_id
                AND rci.column_id = c.referenced_column_id
                WHERE fk.object_id = c.constraint_object_id
            ),
            ')'
        ) END
    FROM sys.foreign_keys fk
    INNER JOIN sys.tables t ON fk.referenced_object_id = t.object_id
    LEFT JOIN tSQLt.Private_FakeTableLog ftl ON t.object_id = ftl.[object_id]
    WHERE fk.[schema_id] = SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName)))
    AND fk.[name] = OBJECT_NAME(@ConstraintId)

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