CREATE PROCEDURE tSQLt.Private_RenameObject
    @ObjectId INT,
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    SET @NewName = ISNULL(@NewName, NEWID());

    DECLARE @Command NVARCHAR(MAX) = CONCAT
    (
        'EXEC sp_rename ''',
        QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)),
        '.',
        QUOTENAME(OBJECT_NAME(@ObjectId)),
        ''', ''',
        @NewName,
        ''', ''OBJECT'';'
    );

    EXEC (@Command);
END;
GO