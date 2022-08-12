CREATE PROCEDURE tSQLt.Private_GetSpyProcedureLogColumns
    @SpyProcedureLogColumns NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectId

    SELECT
        @SpyProcedureLogColumns = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                REPLACE(name, '@', ''),
                CASE
                    WHEN is_table_type = 1 THEN 'xml'
                    ELSE tSQLt.Private_GetType2(user_type_id, max_length, precision, scale, NULL)
                END,
                'NULL'
            ),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM
    (
        SELECT *, is_table_type = (SELECT is_table_type FROM tSQLt.System_Types2(user_type_id))
        FROM @System_Parameters
    ) P
END;
GO