CREATE PROCEDURE tSQLt.Private_GetScalarReturnType
    @ScalarReturnType NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectName

    DECLARE
        @user_type_id [int],
        @max_length [smallint],
        @precision [tinyint],
        @scale [tinyint]

    SELECT
        @user_type_id = [user_type_id],
        @max_length = [max_length],
        @precision = [precision],
        @scale = [scale]
    FROM @System_Parameters
    WHERE parameter_id = 0

    EXEC tSQLt.Private_GetType @ObjectName, @ScalarReturnType OUTPUT, @user_type_id, @max_length, @precision, @scale
END;
GO