CREATE PROCEDURE tSQLt.Private_ProcessTriggerName
    @ObjectName NVARCHAR(MAX) OUTPUT,
    @TableName NVARCHAR(MAX),
    @TriggerName NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.AssertObjectExists @TableName;

    DECLARE @FakeObjectName NVARCHAR(MAX);
    SELECT
        @FakeObjectName = FakeObjectName
    FROM tSQLt.Private_FakeTables
    WHERE FakeObjectId = OBJECT_ID(@TableName)

    IF @FakeObjectName IS NULL
    BEGIN
        EXEC tSQLt.Fail 'Table', @TableName, 'was not faked by tSQLt.FakeTable.';
    END

    DECLARE @System_Objects tSQLt.System_ObjectsType
    INSERT INTO @System_Objects
    EXEC tSQLt.System_Objects @FakeObjectName, @ParentObjectFilter = 1

    SELECT
        @ObjectName = CONCAT(QUOTENAME(SCHEMA_NAME([schema_id])), '.', QUOTENAME([name]))
    FROM @System_Objects
    WHERE [name] = @TriggerName OR QUOTENAME([name]) = @TriggerName
END;
GO