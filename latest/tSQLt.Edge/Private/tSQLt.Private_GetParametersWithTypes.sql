CREATE FUNCTION tSQLt.Private_GetParametersWithTypes (@ObjectId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    DECLARE @Result NVARCHAR(MAX) =
    (
        SELECT STRING_AGG(name + ' ' + tSQLt.Private_GetType(user_type_id, max_length, precision, scale, NULL), ', ') WITHIN GROUP (ORDER BY parameter_id)
        FROM sys.parameters
        WHERE object_id = @ObjectId
    );

    RETURN ISNULL(@Result, '');
END;
GO