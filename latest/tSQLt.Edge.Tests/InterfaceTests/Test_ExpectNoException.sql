CREATE SCHEMA Test_ExpectNoException;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_EmptyExec
AS
BEGIN
    EXEC tSQLt.ExpectNoException;
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_GoodSelect
AS
BEGIN
    EXEC tSQLt.ExpectNoException;

    SELECT 1.0 A INTO #Good;
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Fail_FailSelect
AS
BEGIN
    EXEC tSQLt.ExpectNoException;

    SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_FailSelect
AS
BEGIN
    EXEC Test_Extensions.AssertTestFails
        @TestName = 'Test_ExpectNoException.Fail_FailSelect',
        @ExpectedMessage = 'Expected no exception to be raised. ErrorMessage:<Divide by zero error encountered.>.';
END;
GO