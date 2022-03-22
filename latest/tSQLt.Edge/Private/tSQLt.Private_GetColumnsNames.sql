CREATE FUNCTION tSQLt.Private_GetColumnsNames (@ObjectName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT
            STRING_AGG
            (
                QUOTENAME(name),
                ', '
            ) WITHIN GROUP (ORDER BY column_id)
        FROM tSQLt.System_Columns(@ObjectName)
    );
END;
GO