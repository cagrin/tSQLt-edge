CREATE PROCEDURE tSQLt.Private_GetScalarParameters
    @ScalarParameters NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectId
    
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