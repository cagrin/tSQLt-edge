CREATE PROCEDURE tSQLt.Private_GetParametersNames
    @ParametersNames NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    SELECT
        @ParametersNames = STRING_AGG
        (
            REPLACE(name, '@', ''),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM tSQLt.System_Parameters(@ObjectId)
END;
GO