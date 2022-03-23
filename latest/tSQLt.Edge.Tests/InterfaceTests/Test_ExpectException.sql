CREATE SCHEMA Test_ExpectException;
GO

CREATE PROCEDURE Test_ExpectException.Fail_EmptyExec
AS
BEGIN
    EXEC tSQLt.ExpectException;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_EmptyExec
AS
BEGIN
    EXEC Test_Extensions.AssertTestFails
        @TestName = 'Test_ExpectException.Fail_EmptyExec',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedMessage:<(null)>.';
END;
GO

CREATE PROCEDURE Test_ExpectException.Fail_GoodSelect
AS
BEGIN
    EXEC tSQLt.ExpectException 'Error message.';

    SELECT 1.0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_GoodSelect
AS
BEGIN
    EXEC Test_Extensions.AssertTestFails
        @TestName = 'Test_ExpectException.Fail_GoodSelect',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedMessage:<Error message.>.';
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_FailSelect
AS
BEGIN
    EXEC tSQLt.ExpectException 'Divide by zero error encountered.';

    SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Fail_BadErrorMessage
AS
BEGIN
    EXEC tSQLt.ExpectException 'Bad error message.';

    SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_BadErrorMessage
AS
BEGIN
    EXEC Test_Extensions.AssertTestFails
        @TestName = 'Test_ExpectException.Fail_BadErrorMessage',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedMessage:<Bad error message.>. ActualMessage:<Divide by zero error encountered.>.';
END;
GO