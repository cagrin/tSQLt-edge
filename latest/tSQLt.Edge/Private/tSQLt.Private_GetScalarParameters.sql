CREATE PROCEDURE tSQLt.Private_GetScalarParameters
    @ScalarParameters NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    SELECT
        @ScalarParameters = STRING_AGG
        (
            name,
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM tSQLt.System_Parameters(@ObjectId)
    WHERE parameter_id > 0
END;
GO