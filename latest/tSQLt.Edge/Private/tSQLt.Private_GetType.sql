CREATE PROCEDURE tSQLt.Private_GetType
    @Type NVARCHAR(MAX) OUTPUT,
    @TypeId INT,
    @Length INT,
    @Precision INT,
    @Scale INT,
    @CollationName NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @TypeName NVARCHAR(MAX)
    EXEC tSQLt.Private_GetTypeName @TypeName OUTPUT, @TypeId

    SELECT
        @Type = CONCAT
        (
            @TypeName,
            CASE
            WHEN @Length = -1 AND TYPE_NAME(@TypeId) IN ('nchar', 'nvarchar',
                                        'char', 'varchar', 'binary', 'varbinary') THEN '(max)'
            WHEN TYPE_NAME(@TypeId) IN ('nchar', 'nvarchar')                      THEN CONCAT('(', @Length / 2, ')')
            WHEN TYPE_NAME(@TypeId) IN ('char', 'varchar', 'binary', 'varbinary') THEN CONCAT('(', @Length, ')')
            WHEN TYPE_NAME(@TypeId) IN ('decimal', 'numeric')                     THEN CONCAT('(', @Precision, ',', @Scale, ')')
            WHEN TYPE_NAME(@TypeId) IN ('datetime2', 'datetimeoffset', 'time')    THEN CONCAT('(', @Scale, ')')
            ELSE ''
            END,
            CASE
            WHEN @CollationName IS NOT NULL AND CONVERT(NVARCHAR(MAX), DATABASEPROPERTYEX(DB_NAME(), 'Collation')) <> ISNULL(@CollationName, '') THEN CONCAT(' COLLATE ', @CollationName)
            ELSE ''
            END
        )
END;
GO