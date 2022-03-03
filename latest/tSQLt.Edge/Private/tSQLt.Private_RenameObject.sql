CREATE PROCEDURE tSQLt.Private_RenameObject
    @ObjectId INT
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = CONCAT
    (
        'EXEC sp_rename ''',
        QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)),
        '.',
        QUOTENAME(OBJECT_NAME(@ObjectId)),
        ''', ''',
        CAST(NEWID() AS NVARCHAR(MAX)),
        ''', ''OBJECT'';'
    );
    
    EXEC (@Command);
END;
GO