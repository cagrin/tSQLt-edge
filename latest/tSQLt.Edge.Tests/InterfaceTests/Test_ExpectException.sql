CREATE SCHEMA Test_ExpectException;
GO

CREATE PROCEDURE Test_ExpectException.Test_EmptyExec
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException;',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedMessage:<(null)>.';
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_GoodSelect
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException ''Error message.''; SELECT 1.0 A INTO #Fail;',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedMessage:<Error message.>.';
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_GoodSelectWithMessage
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException ''Error message.'', @Message = ''Message.''; SELECT 1.0 A INTO #Fail;',
        @ExpectedMessage = 'Message. Expected an exception to be raised. ExpectedMessage:<Error message.>.';
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_FailSelect
AS
BEGIN
    EXEC tSQLt.ExpectException 'Divide by zero error encountered.';

    SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_BadErrorMessage
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException ''Bad error message.''; SELECT 1/0 A INTO #Fail;',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedMessage:<Bad error message.>. ActualMessage:<Divide by zero error encountered.>.';
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_BadErrorMessageWithMessage
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException ''Bad error message.'', @Message = ''Message.''; SELECT 1/0 A INTO #Fail;',
        @ExpectedMessage = 'Message. Expected an exception to be raised. ExpectedMessage:<Bad error message.>. ActualMessage:<Divide by zero error encountered.>.';
END;
GO