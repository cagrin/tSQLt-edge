CREATE PROCEDURE tSQLt.Private_GetObjectType
    @ObjectType CHAR(2) OUTPUT,
    @ObjectId INT
AS
BEGIN
    DECLARE @System_Objects tSQLt.System_ObjectsType
    INSERT INTO @System_Objects
    EXEC tSQLt.System_Objects

    SELECT
        @ObjectType = type
    FROM @System_Objects
    WHERE object_id = @ObjectId
END;
GO