CREATE PROCEDURE tSQLt.Private_GetParametersNames
    @ParametersNames NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectId
    
    SELECT
        @ParametersNames = STRING_AGG
        (
            REPLACE(name, '@', ''),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM @System_Parameters
END;
GO