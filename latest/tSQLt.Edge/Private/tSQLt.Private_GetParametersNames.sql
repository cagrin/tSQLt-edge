CREATE FUNCTION tSQLt.Private_GetParametersNames (@ObjectId INT)
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
        FROM tSQLt.System_Parameters(@ObjectId)
    );
END;
GO