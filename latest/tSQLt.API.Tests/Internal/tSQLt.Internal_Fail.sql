CREATE PROCEDURE tSQLt.Internal_Fail
    @Message0 NVARCHAR(MAX) = '',
    @Message1 NVARCHAR(MAX) = '',
    @Message2 NVARCHAR(MAX) = '',
    @Message3 NVARCHAR(MAX) = '',
    @Message4 NVARCHAR(MAX) = '',
    @Message5 NVARCHAR(MAX) = '',
    @Message6 NVARCHAR(MAX) = '',
    @Message7 NVARCHAR(MAX) = '',
    @Message8 NVARCHAR(MAX) = '',
    @Message9 NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.Fail', @Message0, @Message1, @Message2, @Message3, @Message4, @Message5, @Message6, @Message7, @Message8, @Message9);
END;
GO