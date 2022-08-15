CREATE PROCEDURE tSQLt.Private_RenameObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    SET @NewName = ISNULL(@NewName, NEWID());

    DECLARE @QuotedObjectName NVARCHAR(MAX);
    EXEC tSQLt.Private_GetQuotedObjectName @QuotedObjectName OUTPUT, @ObjectName;

    DECLARE @DatabaseName NVARCHAR(MAX);
    SELECT @DatabaseName = CASE WHEN PARSENAME(@ObjectName, 3) IS NOT NULL THEN CONCAT(QUOTENAME(PARSENAME(@ObjectName, 3)), '.') END

    DECLARE @Command NVARCHAR(MAX) = CONCAT
    (
        'EXEC ', REPLACE(@DatabaseName, '''', ''''''), 'sys.sp_rename ''',
        REPLACE(@QuotedObjectName, '''', ''''''),
        ''', ''',
        @NewName,
        ''', ''OBJECT'';'
    );

    SET @NewName = CONCAT
    (
        @DatabaseName,
        QUOTENAME(PARSENAME(@QuotedObjectName, 2)), '.',
        QUOTENAME(@NewName)
    );

    EXEC (@Command);
END;
GO