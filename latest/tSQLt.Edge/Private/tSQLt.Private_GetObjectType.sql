CREATE FUNCTION tSQLt.Private_GetObjectType (@ObjectId INT)
RETURNS CHAR(2) AS
BEGIN
    RETURN
    (
        SELECT type
        FROM tSQLt.System_Objects()
        WHERE object_id = @ObjectId
    );
END;
GO