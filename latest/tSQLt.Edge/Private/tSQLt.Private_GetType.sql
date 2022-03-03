CREATE FUNCTION tSQLt.Private_GetType (@TypeId INT, @Length INT, @Precision INT, @Scale INT, @CollationName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX) AS
BEGIN
    DECLARE @Result NVARCHAR(MAX) =
    (
        SELECT
            CONCAT
            (
                TYPE_NAME(@TypeId),
                CASE
                WHEN @Length = -1                                                     THEN '(max)'
                WHEN TYPE_NAME(@TypeId) IN ('nchar', 'nvarchar')                      THEN CONCAT('(', @Length / 2, ')')
                WHEN TYPE_NAME(@TypeId) IN ('char', 'varchar', 'binary', 'varbinary') THEN CONCAT('(', @Length, ')')
                WHEN TYPE_NAME(@TypeId) IN ('decimal', 'numeric')                     THEN CONCAT('(', @Precision, ',', @Scale, ')')
                WHEN TYPE_NAME(@TypeId) IN ('datetime2', 'datetimeoffset', 'time')    THEN CONCAT('(', @Scale, ')')
                ELSE ''
                END
            )
    );

    RETURN ISNULL(@Result, '');
END;
GO