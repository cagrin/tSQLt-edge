CREATE TABLE tSQLt.System_TableTypeColumnsCache
(
    TableTypeColumns NVARCHAR(MAX),
    TableTypeName NVARCHAR(MAX)
);
GO

CREATE PROCEDURE tSQLt.System_GetTableTypeColumns
    @TableTypeColumns NVARCHAR(MAX) OUTPUT,
    @TableTypeName NVARCHAR(MAX)
AS
BEGIN
    SELECT
        @TableTypeColumns = TableTypeColumns
    FROM tSQLt.System_TableTypeColumnsCache
    WHERE TableTypeName = @TableTypeName

    IF @TableTypeColumns IS NULL
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

        INSERT INTO tSQLt.System_TableTypeColumnsCache (TableTypeColumns, TableTypeName)
        SELECT @TableTypeColumns, @TableTypeName
    END
END;
GO