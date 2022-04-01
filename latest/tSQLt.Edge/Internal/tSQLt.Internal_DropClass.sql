CREATE PROCEDURE tSQLt.Internal_DropClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.Fail 'tSQLt.DropClass is not supported.';
END;
GO