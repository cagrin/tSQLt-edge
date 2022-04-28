CREATE PROCEDURE tSQLt.ExpectNoException
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_ExpectNoException';
    EXEC @Command
    @Message = @Message;
END;
GO