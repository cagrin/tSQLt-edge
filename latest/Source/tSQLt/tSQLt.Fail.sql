CREATE PROCEDURE tSQLt.Fail
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
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_Fail';
    EXEC @Command
    @Message0 = @Message0,
    @Message1 = @Message1,
    @Message2 = @Message2,
    @Message3 = @Message3,
    @Message4 = @Message4,
    @Message5 = @Message5,
    @Message6 = @Message6,
    @Message7 = @Message7,
    @Message8 = @Message8,
    @Message9 = @Message9;
END;
GO