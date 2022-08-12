CREATE PROCEDURE tSQLt.Private_GetSpyProcedureLogSelect
    @SpyProcedureLogSelect NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectId

    SELECT
        @SpyProcedureLogSelect = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                CASE
                    WHEN is_table_type = 1 THEN CONCAT('(SELECT * FROM ', name, ' FOR XML PATH(''row''),TYPE,ROOT(''', REPLACE(name, '@', ''), '''))')
                    ELSE name
                END,
                CASE WHEN is_output = 1 THEN 'OUTPUT' ELSE NULL END
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