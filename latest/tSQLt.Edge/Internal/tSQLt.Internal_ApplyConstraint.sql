CREATE PROCEDURE tSQLt.Internal_ApplyConstraint
    @TableName NVARCHAR(MAX),
    @ConstraintName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL, --parameter preserved for backward compatibility. Do not use. Will be removed soon.
    @NoCascade BIT = 0
AS
BEGIN

    DECLARE @ObjectName NVARCHAR(MAX) = @TableName;
/*
    IF @SchemaName IS NOT NULL
        SET @ObjectName = CONCAT(@SchemaName, '.', @TableName)
*/
    EXEC tSQLt.AssertObjectExists @ObjectName;

    DECLARE @SchemaId INT = SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName)))

    DECLARE @ConstraintId INT, @ConstraintDefinition NVARCHAR(MAX), @ParentName NVARCHAR(MAX)
    SELECT
        @ConstraintId = [object_id],
        @ConstraintDefinition = [definition],
        @ParentName = CONCAT(QUOTENAME(SCHEMA_NAME(@SchemaId)), '.', QUOTENAME(OBJECT_NAME([parent_object_id])))
    FROM sys.check_constraints
    WHERE [schema_id] = @SchemaId
    AND [name] = @ConstraintName

    DECLARE @CreateConstraint NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'CHECK', @ConstraintDefinition
    )

    EXEC (@CreateConstraint);
END;
GO