CREATE PROCEDURE tSQLt.Private_GetScalarReturnType
    @ScalarReturnType NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    SELECT
        @ScalarReturnType = tSQLt.Private_GetType(user_type_id, max_length, precision, scale, NULL)
    FROM tSQLt.System_Parameters(@ObjectId)
    WHERE parameter_id = 0
END;
GO