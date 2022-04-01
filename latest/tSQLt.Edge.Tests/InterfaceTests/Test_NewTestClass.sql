CREATE SCHEMA Test_NewTestClass;
GO

CREATE PROCEDURE Test_NewTestClass.Test_IsUnsupported
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.NewTestClass is not supported. Use CREATE SCHEMA ''ClassName''.'

    EXEC tSQLt.NewTestClass 'TestClass1';
END;
GO