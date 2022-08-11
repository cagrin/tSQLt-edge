CREATE PROCEDURE tSQLt.Private_GetScalarReturnType
    @ScalarReturnType NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectId
    
    SELECT
        @ScalarReturnType = tSQLt.Private_GetType(user_type_id, max_length, precision, scale, NULL)
    FROM @System_Parameters
    WHERE parameter_id = 0
END;
GO