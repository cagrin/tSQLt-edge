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

    DECLARE @ObjectId INT, @FakeObjectName NVARCHAR(MAX);
    SELECT
        @ObjectId = ObjectId,
        @FakeObjectName = FakeObjectName
    FROM tSQLt.Private_FakeTables
    WHERE FakeObjectId = OBJECT_ID(@ObjectName)

    IF @ObjectId IS NULL
    BEGIN
        EXEC tSQLt.Fail 'Table', @ObjectName, 'was not faked by tSQLt.FakeTable.';
    END
    ELSE
    BEGIN
        SET @ParentName = CONCAT(QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)), '.', QUOTENAME(OBJECT_NAME(@ObjectId)))
    END

    DECLARE @System_Objects tSQLt.System_ObjectsType
    INSERT INTO @System_Objects
    EXEC tSQLt.System_Objects @FakeObjectName, @ParentObjectFilter = 1

    SELECT
        @ConstraintId = [object_id],
        @ConstraintType = [type]
    FROM @System_Objects
    WHERE [name] = @ConstraintName OR QUOTENAME([name]) = @ConstraintName
END;
GO