CREATE PROCEDURE tSQLt.Private_GetObjectType
    @ObjectType CHAR(2) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @System_Objects tSQLt.System_ObjectsType
    INSERT INTO @System_Objects
    EXEC tSQLt.System_Objects

    SELECT
        @ObjectType = type
    FROM @System_Objects
    WHERE object_id = OBJECT_ID(@ObjectName)
END;
GO