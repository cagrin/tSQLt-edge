CREATE PROCEDURE tSQLt.Private_GetScalarParameters
    @ScalarParameters NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectName

    SELECT
        @ScalarParameters = STRING_AGG
        (
            name,
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM @System_Parameters
    WHERE parameter_id > 0
END;
GO