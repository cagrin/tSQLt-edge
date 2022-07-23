CREATE PROCEDURE tSQLt.Private_GetColumnsNames
    @ColumnsNames NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    SELECT
        @ColumnsNames = STRING_AGG
        (
            QUOTENAME(name),
            ', '
        ) WITHIN GROUP (ORDER BY column_id)
    FROM tSQLt.System_Columns(@ObjectName)
END;
GO