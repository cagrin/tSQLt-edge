CREATE PROCEDURE tSQLt.DropClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_DropClass';
    EXEC @Command
    @ClassName = @ClassName;
END;
GO