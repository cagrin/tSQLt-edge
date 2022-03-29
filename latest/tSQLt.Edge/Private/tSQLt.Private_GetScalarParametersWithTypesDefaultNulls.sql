CREATE FUNCTION tSQLt.Private_GetScalarParametersWithTypesDefaultNulls (@ObjectId INT)
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
                    '= NULL',
                    CASE WHEN is_output = 1 THEN 'OUTPUT' ELSE NULL END
                ),
                ', '
            ) WITHIN GROUP (ORDER BY parameter_id)
        FROM tSQLt.System_Parameters(@ObjectId)
        WHERE parameter_id > 0
    );
END;
GO