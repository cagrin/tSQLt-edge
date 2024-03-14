CREATE SCHEMA Test_NewTestClass;
GO

CREATE PROCEDURE Test_NewTestClass.Test_IsUnsupported
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.NewTestClass of TestClass1 is not supported.'

    EXEC tSQLt.NewTestClass 'TestClass1';
END;
GO