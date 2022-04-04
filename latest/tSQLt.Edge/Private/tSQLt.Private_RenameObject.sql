CREATE PROCEDURE tSQLt.Private_RenameObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    SET @NewName = ISNULL(@NewName, NEWID());

    DECLARE @Command NVARCHAR(MAX) = CONCAT
    (
        'EXEC sp_rename ''',
        tSQLt.Private_GetQuotedObjectName(@ObjectName),
        ''', ''',
        @NewName,
        ''', ''OBJECT'';'
    );

    EXEC (@Command);
END;
GO