CREATE FUNCTION tSQLt.Private_GetParameters (@ObjectId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT
            STRING_AGG
            (
                name,
                ', '
            ) WITHIN GROUP (ORDER BY parameter_id)
        FROM sys.parameters
        WHERE object_id = @ObjectId
    );
END;
GO