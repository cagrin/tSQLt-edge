CREATE PROCEDURE tSQLt.RemoveObjectIfExists
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_RemoveObjectIfExists';
    EXEC @Command
    @ObjectName = @ObjectName,
    @NewName = @NewName OUTPUT;
END;
GO