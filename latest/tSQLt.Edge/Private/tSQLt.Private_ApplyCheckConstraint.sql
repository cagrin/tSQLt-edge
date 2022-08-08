CREATE PROCEDURE tSQLt.Private_ApplyCheckConstraint
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT
AS
BEGIN
    DECLARE @System_CheckConstraints tSQLt.System_CheckConstraintsType
    INSERT INTO @System_CheckConstraints
    EXEC tSQLt.System_CheckConstraints

    DECLARE @ParentName NVARCHAR(MAX), @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX);
    SELECT
        @ParentName = CONCAT(QUOTENAME(SCHEMA_NAME([schema_id])), '.', QUOTENAME(OBJECT_NAME([parent_object_id]))),
        @ConstraintName = QUOTENAME(OBJECT_NAME([object_id])),
        @ConstraintDefinition = [definition]
    FROM @System_CheckConstraints
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