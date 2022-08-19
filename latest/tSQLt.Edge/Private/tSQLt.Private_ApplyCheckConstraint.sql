CREATE PROCEDURE tSQLt.Private_ApplyCheckConstraint
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT
AS
BEGIN
    EXEC tSQLt.Private_GetQuotedObjectName @ObjectName OUTPUT, @ObjectName;

    DECLARE @System_CheckConstraints tSQLt.System_CheckConstraintsType
    INSERT INTO @System_CheckConstraints
    EXEC tSQLt.System_CheckConstraints @ObjectName, @ConstraintId

    DECLARE @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX);
    SELECT
        @ConstraintName = QUOTENAME([name]),
        @ConstraintDefinition = [definition]
    FROM @System_CheckConstraints

    DECLARE @ParentName NVARCHAR(MAX);
    SELECT
        @ParentName = FakeObjectName
    FROM tSQLt.Private_FakeTables
    WHERE ObjectName = @ObjectName

    DECLARE @CreateConstraint NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'CHECK', @ConstraintDefinition
    )

    EXEC (@CreateConstraint);
END;
GO