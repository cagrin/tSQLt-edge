CREATE PROCEDURE tSQLt.Private_GetColumnsNames
    @ColumnsNames NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @System_Columns tSQLt.System_ColumnsType;
    INSERT INTO @System_Columns
    EXEC tSQLt.System_Columns @ObjectName

    SELECT
        @ColumnsNames = STRING_AGG
        (
            QUOTENAME(name),
            ', '
        ) WITHIN GROUP (ORDER BY column_id)
    FROM @System_Columns
END;
GO