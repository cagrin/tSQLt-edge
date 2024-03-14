CREATE SCHEMA Test_DropClass;
GO

CREATE PROCEDURE Test_DropClass.Test_IsUnsupported
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.DropClass of TestClass1 is not supported.'

    EXEC tSQLt.DropClass 'TestClass1';
END;
GO