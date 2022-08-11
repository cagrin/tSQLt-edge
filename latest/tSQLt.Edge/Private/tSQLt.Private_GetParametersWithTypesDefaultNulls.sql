CREATE PROCEDURE tSQLt.Private_GetParametersWithTypesDefaultNulls
    @ParametersWithTypesDefaultNulls NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectId
    
    SELECT
        @ParametersWithTypesDefaultNulls = STRING_AGG
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
    FROM @System_Parameters
END;
GO