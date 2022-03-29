CREATE FUNCTION tSQLt.Private_GetScalarReturnType (@ObjectId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT
            tSQLt.Private_GetType(user_type_id, max_length, precision, scale, NULL)
        FROM tSQLt.System_Parameters(@ObjectId)
        WHERE parameter_id = 0
    );
END;
GO