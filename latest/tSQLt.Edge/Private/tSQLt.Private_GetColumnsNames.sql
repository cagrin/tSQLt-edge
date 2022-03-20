CREATE FUNCTION tSQLt.Private_GetColumnsNames (@ObjectId INT)
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
        FROM sys.columns
        WHERE object_id = @ObjectId
    );
END;
GO