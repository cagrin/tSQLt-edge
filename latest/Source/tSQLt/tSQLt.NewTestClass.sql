CREATE PROCEDURE tSQLt.NewTestClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_NewTestClass';
    EXEC @Command
    @ClassName = @ClassName;
END;
GO