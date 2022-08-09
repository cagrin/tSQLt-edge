CREATE PROCEDURE tSQLt.Private_GetComputedColumn
    @ComputedColumn NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX),
    @ColumnId INT
AS
BEGIN
    DECLARE @System_ComputedColumns tSQLt.System_ComputedColumnsType
    INSERT INTO @System_ComputedColumns
    EXEC tSQLt.System_ComputedColumns @ObjectName, @ColumnId

    SELECT @ComputedColumn = CONCAT_WS
    (
        ' ',
        'AS',
        definition,
        CASE WHEN is_persisted = 1 THEN 'PERSISTED' ELSE NULL END
    )
    FROM @System_ComputedColumns
END;
GO