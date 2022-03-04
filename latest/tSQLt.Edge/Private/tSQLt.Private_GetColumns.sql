CREATE FUNCTION tSQLt.Private_GetColumns (@ObjectId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT
            STRING_AGG
            (
                REPLACE(name, '@', ''),
                ', '
            ) WITHIN GROUP (ORDER BY parameter_id)
        FROM sys.parameters
        WHERE object_id = @ObjectId
    );
END;
GO