CREATE PROCEDURE tSQLt.Private_RenameObject
    @ObjectId INT
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = FORMATMESSAGE
    (
        'EXEC sp_rename ''%s.%s'', ''%s'', ''OBJECT'';',
        QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)),
        QUOTENAME(OBJECT_NAME(@ObjectId)),
        CAST(NEWID() AS NVARCHAR(MAX))
    );
    EXEC (@Command);
END;
GO