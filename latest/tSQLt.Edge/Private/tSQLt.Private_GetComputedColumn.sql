CREATE FUNCTION tSQLt.Private_GetComputedColumn (@ObjectName NVARCHAR(MAX), @ColumnId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT CONCAT_WS(' ', 'AS', definition, CASE WHEN is_persisted = 1 THEN 'PERSISTED' ELSE NULL END)
        FROM tSQLt.System_ComputedColumns(@ObjectName, @ColumnId)
    );
END;
GO