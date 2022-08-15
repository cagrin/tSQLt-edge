CREATE PROCEDURE tSQLt.System_GetTableTypeColumns
    @TableTypeColumns NVARCHAR(MAX) OUTPUT,
    @TableTypeName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @ObjectId INT
    SELECT
        @ObjectId = type_table_object_id
    FROM sys.table_types
    WHERE name = @TableTypeName

    SELECT
        @TableTypeColumns = STRING_AGG
        (
            QUOTENAME(name),
            ', '
        )  WITHIN GROUP (ORDER BY column_id)
    FROM sys.columns
    WHERE object_id = @ObjectId
END;
GO