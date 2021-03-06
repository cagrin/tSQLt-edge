CREATE FUNCTION tSQLt.Private_GetParametersWithTypes (@ObjectId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT
            STRING_AGG
            (
                CONCAT_WS
                (
                    ' ',
                    name,
                    tSQLt.Private_GetType(user_type_id, max_length, precision, scale, NULL),
                    CASE WHEN is_output = 1 THEN 'OUTPUT' ELSE NULL END
                ),
                ', '
            ) WITHIN GROUP (ORDER BY parameter_id)
        FROM tSQLt.System_Parameters(@ObjectId)
    );
END;
GO