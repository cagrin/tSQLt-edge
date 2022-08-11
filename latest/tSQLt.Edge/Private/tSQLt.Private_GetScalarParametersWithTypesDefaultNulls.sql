CREATE PROCEDURE tSQLt.Private_GetScalarParametersWithTypesDefaultNulls
    @ScalarParametersWithTypesDefaultNulls NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    SELECT
        @ScalarParametersWithTypesDefaultNulls = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                name,
                tSQLt.Private_GetType(user_type_id, max_length, precision, scale, NULL),
                CASE WHEN is_readonly = 1 THEN 'READONLY' ELSE '= NULL' END,
                CASE WHEN is_output = 1 THEN 'OUTPUT' ELSE NULL END
            ),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM tSQLt.System_Parameters(@ObjectId)
    WHERE parameter_id > 0
END;
GO