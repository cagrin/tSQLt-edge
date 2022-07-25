CREATE PROCEDURE tSQLt.Private_GetComputedColumn
    @ComputedColumn NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX),
    @ColumnId INT
AS
BEGIN
    SELECT @ComputedColumn = CONCAT_WS
    (
        ' ',
        'AS',
        definition,
        CASE WHEN is_persisted = 1 THEN 'PERSISTED' ELSE NULL END
    )
    FROM tSQLt.System_ComputedColumns(@ObjectName, @ColumnId)
END;
GO