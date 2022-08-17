CREATE PROCEDURE tSQLt.Private_ApplyUniqueConstraint
    @ParentName NVARCHAR(MAX),
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT
AS
BEGIN
    DECLARE @System_IndexColumns tSQLt.System_IndexColumnsType
    INSERT INTO @System_IndexColumns
    EXEC tSQLt.System_IndexColumns @ParentName

    DECLARE @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX);
    SELECT
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
    WHERE [index_name] = OBJECT_NAME(@ConstraintId)
    AND [is_unique_constraint] = 1
    GROUP BY [index_name], [type_desc]

    DECLARE @CreateUniqueConstraint NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'UNIQUE', @ConstraintDefinition
    )

    EXEC (@CreateUniqueConstraint);
END;
GO