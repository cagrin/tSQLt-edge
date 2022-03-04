CREATE FUNCTION tSQLt.Private_GetColumnsWithTypes (@ObjectId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT
            STRING_AGG
            (
                CONCAT_WS
                (
                    ' ',
                    REPLACE(name, '@', ''),
                    tSQLt.Private_GetType(user_type_id, max_length, precision, scale, NULL)
                ),
                ', '
            ) WITHIN GROUP (ORDER BY parameter_id)
        FROM sys.parameters
        WHERE object_id = @ObjectId
    );
END;
GO