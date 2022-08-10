CREATE PROCEDURE tSQLt.Private_ProcessTriggerName
    @ObjectName NVARCHAR(MAX) OUTPUT,
    @TriggerId INT OUTPUT,
    @TableName NVARCHAR(MAX),
    @TriggerName NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.AssertObjectExists @TableName;

    DECLARE @ObjectId INT;
    SELECT
        @ObjectId = ObjectId
    FROM tSQLt.Private_FakeTables
    WHERE FakeObjectId = OBJECT_ID(@TableName)

    IF @ObjectId IS NULL
    BEGIN
        EXEC tSQLt.Fail 'Table', @TableName, 'was not faked by tSQLt.FakeTable.';
    END

    DECLARE @System_Objects tSQLt.System_ObjectsType
    INSERT INTO @System_Objects
    EXEC tSQLt.System_Objects

    SELECT
        @TriggerId = [object_id],
        @ObjectName = CONCAT(QUOTENAME(SCHEMA_NAME([schema_id])), '.', QUOTENAME([name]))
    FROM @System_Objects
    WHERE [parent_object_id] = @ObjectId
    AND ([name] = @TriggerName OR QUOTENAME([name]) = @TriggerName)
END;
GO