CREATE SCHEMA Test_RenameClass;
GO

CREATE PROCEDURE Test_RenameClass.Test_IsUnsupported
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.RenameClass of TestClass1 to NewTestClass1 is not supported.'

    EXEC tSQLt.RenameClass 'TestClass1', 'NewTestClass1';
END;
GO