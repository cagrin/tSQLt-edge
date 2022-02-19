CREATE PROCEDURE tSQLt.Internal_NewTestClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.NewTestClass', @ClassName);
END;
GO