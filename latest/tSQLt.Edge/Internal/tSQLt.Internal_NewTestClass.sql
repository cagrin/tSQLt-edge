CREATE PROCEDURE tSQLt.Internal_NewTestClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.Fail 'tSQLt.NewTestClass of', @ClassName, 'is not supported.';
END;
GO