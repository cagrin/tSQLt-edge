CREATE PROCEDURE tSQLt.Private_RenameObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    SET @NewName = ISNULL(@NewName, NEWID());

    DECLARE @QuotedObjectName NVARCHAR(MAX);
    EXEC tSQLt.Private_GetQuotedObjectName @QuotedObjectName OUTPUT, @ObjectName;

    DECLARE @Command NVARCHAR(MAX) = CONCAT
    (
        'EXEC sp_rename ''',
        REPLACE(@QuotedObjectName, '''', ''''''),
        ''', ''',
        @NewName,
        ''', ''OBJECT'';'
    );

    EXEC (@Command);
END;
GO