CREATE PROCEDURE tSQLt.Private_ProcessConstraintName
    @ParentName NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX) OUTPUT,
    @ConstraintId INT OUTPUT,
    @ConstraintType CHAR(2) OUTPUT,
    @TableName NVARCHAR(MAX),
    @ConstraintName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL
AS
BEGIN
    IF SCHEMA_ID(@TableName) IS NOT NULL AND OBJECT_ID(CONCAT(@TableName, '.', @ConstraintName), 'U') IS NOT NULL
    BEGIN
        DECLARE @TableName1 NVARCHAR(MAX) = @ConstraintName, @ConstraintName1 NVARCHAR(MAX) = @SchemaName, @SchemaName1 NVARCHAR(MAX) = @TableName;
        SELECT @TableName = @TableName1, @ConstraintName = @ConstraintName1, @SchemaName = @SchemaName1
    END

    SET @ObjectName = @TableName;

    IF @SchemaName IS NOT NULL
    BEGIN
        SET @ObjectName = CONCAT(@SchemaName, '.', @TableName);
    END

    EXEC tSQLt.AssertObjectExists @ObjectName;

    DECLARE @QuotedObjectName NVARCHAR(MAX)
    EXEC tSQLt.Private_GetQuotedObjectName @QuotedObjectName OUTPUT, @ObjectName;

    SELECT
        @ParentName = FakeObjectName
    FROM tSQLt.Private_FakeTables
    WHERE ObjectName = @QuotedObjectName

    IF @ParentName IS NULL
    BEGIN
        EXEC tSQLt.Fail 'Table', @ObjectName, 'was not faked by tSQLt.FakeTable.';
    END

    DECLARE @System_Objects tSQLt.System_ObjectsType
    INSERT INTO @System_Objects
    EXEC tSQLt.System_Objects @ParentName, @ParentObjectFilter = 1

    SELECT
        @ConstraintId = [object_id],
        @ConstraintType = [type]
    FROM @System_Objects
    WHERE [name] = @ConstraintName OR QUOTENAME([name]) = @ConstraintName
END;
GO