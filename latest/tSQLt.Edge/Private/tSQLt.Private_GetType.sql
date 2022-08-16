CREATE PROCEDURE tSQLt.Private_GetType
    @Type NVARCHAR(MAX) OUTPUT,
    @TypeId INT,
    @Length INT,
    @Precision INT,
    @Scale INT,
    @CollationName NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @TypeName NVARCHAR(MAX) = TYPE_NAME(@TypeId)
    IF @TypeId > 256
    BEGIN
        EXEC tSQLt.Private_GetTypeName @TypeName OUTPUT, @TypeId
    END

    SELECT
        @Type = CONCAT
        (
            @TypeName,
            CASE
            WHEN @Length = -1 AND @TypeName IN ('nchar', 'nvarchar', 'char', 'varchar', 'binary', 'varbinary') THEN '(max)'
            WHEN @TypeName IN ('nchar', 'nvarchar')                      THEN CONCAT('(', @Length / 2, ')')
            WHEN @TypeName IN ('char', 'varchar', 'binary', 'varbinary') THEN CONCAT('(', @Length, ')')
            WHEN @TypeName IN ('decimal', 'numeric')                     THEN CONCAT('(', @Precision, ',', @Scale, ')')
            WHEN @TypeName IN ('datetime2', 'datetimeoffset', 'time')    THEN CONCAT('(', @Scale, ')')
            ELSE ''
            END,
            CASE
            WHEN @CollationName IS NOT NULL AND CONVERT(NVARCHAR(MAX), DATABASEPROPERTYEX(DB_NAME(), 'Collation')) <> ISNULL(@CollationName, '') THEN CONCAT(' COLLATE ', @CollationName)
            ELSE ''
            END
        )
END;
GO