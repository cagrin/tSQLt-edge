CREATE PROCEDURE tSQLt.Private_ApplyCheckConstraint
    @ParentName NVARCHAR(MAX),
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT
AS
BEGIN
    DECLARE @System_CheckConstraints tSQLt.System_CheckConstraintsType
    INSERT INTO @System_CheckConstraints
    EXEC tSQLt.System_CheckConstraints @ObjectName, @ConstraintId

    DECLARE @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX);
    SELECT
        @ConstraintName = QUOTENAME([name]),
        @ConstraintDefinition = [definition]
    FROM @System_CheckConstraints

    DECLARE @CreateConstraint NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'CHECK', @ConstraintDefinition
    )

    EXEC sys.sp_executesql @CreateConstraint;
END;
GO