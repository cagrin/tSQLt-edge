CREATE PROCEDURE tSQLt.Private_GetParametersWithTypes
    @ParametersWithTypes NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectId

    SELECT
        @ParametersWithTypes = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                name,
                tSQLt.Private_GetType2(user_type_id, max_length, precision, scale, NULL),
                CASE WHEN is_output = 1 THEN 'OUTPUT' ELSE NULL END
            ),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM @System_Parameters
END;
GO