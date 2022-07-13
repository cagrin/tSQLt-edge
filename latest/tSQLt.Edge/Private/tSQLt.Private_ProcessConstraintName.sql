CREATE PROCEDURE tSQLt.Private_ProcessConstraintName
    @ObjectName NVARCHAR(MAX) OUTPUT,
    @ConstraintId INT OUTPUT,
    @ConstraintType CHAR(2) OUTPUT,
    @TableName NVARCHAR(MAX),
    @ConstraintName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL
AS
BEGIN
    SET @ObjectName = @TableName;

    IF @SchemaName IS NOT NULL
        SET @ObjectName = CONCAT(@SchemaName, '.', @TableName)

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