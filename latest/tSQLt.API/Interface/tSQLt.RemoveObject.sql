CREATE PROCEDURE tSQLt.RemoveObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT,
    @IfExists INT = 0
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_RemoveObject';
    EXEC @Command
    @ObjectName = @ObjectName,
    @NewName = @NewName,
    @IfExists = @IfExists;
END;
GO