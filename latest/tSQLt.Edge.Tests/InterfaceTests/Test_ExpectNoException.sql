CREATE SCHEMA Test_ExpectNoException;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_EmptyExec
AS
BEGIN
    EXEC tSQLt.ExpectNoException;
END;
GO