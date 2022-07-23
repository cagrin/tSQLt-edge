CREATE PROCEDURE tSQLt.Private_GetMetaData
    @CommandToExecute NVARCHAR(MAX),
    @MetaData NVARCHAR(MAX) OUTPUT
AS
BEGIN
    EXEC tSQLt.Private_RemoveLastCharacter @CommandToExecute OUTPUT, @Character = ';'

    DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'SELECT TOP 1 * INTO #MetaData FROM (', @CommandToExecute, ') A;',
        'EXEC tSQLt.Private_GetColumns @MetaData OUTPUT, ''#MetaData'';'
    );

    EXEC sys.sp_executesql @Command, N'@MetaData NVARCHAR(MAX) OUTPUT', @MetaData OUTPUT;
END;
GO