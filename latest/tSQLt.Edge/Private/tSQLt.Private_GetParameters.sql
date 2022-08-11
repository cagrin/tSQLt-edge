CREATE PROCEDURE tSQLt.Private_GetParameters
    @Parameters NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    SELECT
        @Parameters = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                name,
                CASE WHEN is_output = 1 THEN 'OUTPUT' ELSE NULL END
            ),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM tSQLt.System_Parameters(@ObjectId)
END;
GO