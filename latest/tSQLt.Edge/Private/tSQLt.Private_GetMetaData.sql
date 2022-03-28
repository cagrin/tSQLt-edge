CREATE PROCEDURE tSQLt.Private_GetMetaData
    @CommandToExecute NVARCHAR(MAX),
    @MetaData NVARCHAR(MAX) OUTPUT
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'SELECT TOP 1 * INTO #MetaData FROM (', @CommandToExecute, ') A;',
        'SELECT @MetaData = tSQLt.Private_GetColumns(''#MetaData'');'
    );

    EXEC sys.sp_executesql @Command, N'@MetaData NVARCHAR(MAX) OUTPUT', @MetaData OUTPUT;
END;
GO