CREATE PROCEDURE tSQLt.Private_ProcessConstraintName
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

    DECLARE @ObjectId INT;
    SELECT
        @ObjectId = ObjectId
    FROM tSQLt.Private_FakeTables
    WHERE FakeObjectId = OBJECT_ID(@ObjectName)

    IF @ObjectId IS NULL
    BEGIN
        EXEC tSQLt.Fail 'Table', @ObjectName, 'was not faked by tSQLt.FakeTable.';
    END

    SELECT
        @ConstraintId = [object_id],
        @ConstraintType = [type]
    FROM tSQLt.System_Objects()
    WHERE [parent_object_id] = @ObjectId
    AND ([name] = @ConstraintName OR QUOTENAME([name]) = @ConstraintName)
END;
GO