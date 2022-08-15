CREATE PROCEDURE tSQLt.Private_GetParametersNames
    @ParametersNames NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectName

    SELECT
        @ParametersNames = STRING_AGG
        (
            REPLACE(name, '@', ''),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM @System_Parameters
END;
GO