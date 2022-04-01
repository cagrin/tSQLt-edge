CREATE PROCEDURE tSQLt.Internal_NewTestClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.Fail 'tSQLt.NewTestClass is not supported. Use CREATE SCHEMA ''ClassName''.';
END;
GO