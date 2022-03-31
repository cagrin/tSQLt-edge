CREATE PROCEDURE tSQLt.Private_RenameObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX);

    IF (OBJECT_ID(CONCAT('tempdb..', @ObjectName)) IS NOT NULL)
    BEGIN
        SET @Command = CONCAT('DROP TABLE ', @ObjectName);
    END
    ELSE
    BEGIN
        SET @NewName = ISNULL(@NewName, NEWID());
        SET @Command = CONCAT
        (
            'EXEC sp_rename ''',
            QUOTENAME(PARSENAME(@ObjectName, 2)),
            '.',
            QUOTENAME(PARSENAME(@ObjectName, 1)),
            ''', ''',
            @NewName,
            ''', ''OBJECT'';'
        );
    END

    EXEC (@Command);
END;
GO