CREATE PROCEDURE tSQLt.Internal_ApplyIndex
    @TableName NVARCHAR(MAX),
    @IndexName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'tSQLt.ApplyIndex failed.',
        CONCAT('Index:<', @IndexName, '> on table <', @TableName,'> does not exist.')
    );
    EXEC tSQLt.Fail @Failed;
END;
GO