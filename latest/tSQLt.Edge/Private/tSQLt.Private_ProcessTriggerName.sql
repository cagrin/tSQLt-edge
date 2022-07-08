CREATE PROCEDURE tSQLt.Private_ProcessTriggerName
    @TableName NVARCHAR(MAX),
    @TriggerName NVARCHAR(MAX) OUTPUT
AS
BEGIN
    EXEC tSQLt.AssertObjectExists @TableName;

    IF NOT EXISTS
    (
        SELECT 1 FROM tSQLt.Private_FakeTables
        WHERE FakeObjectId = OBJECT_ID(@TableName)
    )
    BEGIN
        EXEC tSQLt.Fail 'Table', @TableName, 'was not faked by tSQLt.FakeTable.';
    END

    SET @TriggerName = CONCAT(OBJECT_SCHEMA_NAME(OBJECT_ID(@TableName)), '.', @TriggerName);
    EXEC tSQLt.AssertObjectExists @TriggerName;
END;
GO