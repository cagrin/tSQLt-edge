CREATE PROCEDURE tSQLt.Private_GetParameters
    @Parameters NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectName

    SELECT
        @Parameters = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                name,
                CASE WHEN is_output = 1 THEN 'OUTPUT' ELSE NULL END
            ),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM @System_Parameters
END;
GO