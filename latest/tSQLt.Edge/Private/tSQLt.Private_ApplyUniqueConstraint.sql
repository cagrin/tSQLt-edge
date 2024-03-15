CREATE PROCEDURE tSQLt.Private_ApplyUniqueConstraint
    @ParentName NVARCHAR(MAX),
    @ObjectName NVARCHAR(MAX),
    @ConstraintName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @System_IndexColumns tSQLt.System_IndexColumnsType
    INSERT INTO @System_IndexColumns
    EXEC tSQLt.System_IndexColumns @ParentName

    SET @ConstraintName = QUOTENAME(PARSENAME(@ConstraintName, 1))
    DECLARE @ConstraintDefinition NVARCHAR(MAX);
    SELECT
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
    WHERE QUOTENAME([index_name]) = @ConstraintName
    AND [is_unique_constraint] = 1
    GROUP BY [index_name], [type_desc]

    DECLARE @CreateUniqueConstraint NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'UNIQUE', @ConstraintDefinition
    )

    EXEC sys.sp_executesql @CreateUniqueConstraint;
END;
GO