CREATE PROCEDURE tSQLt.Private_IsEmptyTable
    @TableName NVARCHAR(MAX),
    @IsEmpty BIT OUTPUT
AS
BEGIN
    DECLARE @QuotedObjectName NVARCHAR(MAX);
    EXEC tSQLt.Private_GetQuotedObjectName @QuotedObjectName OUTPUT, @TableName;

    DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'SELECT @IsEmpty = CASE WHEN NOT EXISTS (SELECT 1 FROM', @QuotedObjectName, ') THEN 1 ELSE 0 END;'
    );

    EXEC sys.sp_executesql @Command, N'@IsEmpty BIT OUTPUT', @IsEmpty OUTPUT;
END;
GO