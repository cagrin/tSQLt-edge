CREATE PROCEDURE tSQLt.Private_RenameObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    SET @NewName = ISNULL(@NewName, NEWID());

    DECLARE @Command NVARCHAR(MAX) = CONCAT
    (
        'EXEC sp_rename ''',
        QUOTENAME(PARSENAME(@ObjectName, 2)),
        '.',
        QUOTENAME(PARSENAME(@ObjectName, 1)),
        ''', ''',
        @NewName,
        ''', ''OBJECT'';'
    );

    EXEC (@Command);
END;
GO