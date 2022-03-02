CREATE FUNCTION tSQLt.Private_GetType (@TypeId INT, @Length INT, @Precision INT, @Scale INT, @CollationName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX) AS
BEGIN
    DECLARE @Result NVARCHAR(MAX) =
    (
        SELECT TYPE_NAME(@TypeId) + CASE
            WHEN @Length = -1                                                           THEN '(max)'
            WHEN TYPE_NAME(@TypeId) IN ('nchar', 'nvarchar')                            THEN '(' + CAST(@Length / 2 AS NVARCHAR) + ')'
            WHEN TYPE_NAME(@TypeId) IN ('char', 'varchar', 'binary', 'varbinary')       THEN '(' + CAST(@Length AS NVARCHAR) + ')'
            WHEN TYPE_NAME(@TypeId) IN ('decimal', 'numeric')                           THEN '(' + CAST(@Precision AS NVARCHAR) + ',' + CAST(@Scale AS NVARCHAR) + ')'
            WHEN TYPE_NAME(@TypeId) IN ('datetime2', 'datetimeoffset', 'time')          THEN '(' + CAST(@Scale AS NVARCHAR) + ')'
            ELSE ''
        END
    );

    RETURN ISNULL(@Result, '');
END;
GO