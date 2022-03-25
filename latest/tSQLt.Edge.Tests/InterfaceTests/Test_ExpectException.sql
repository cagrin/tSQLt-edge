CREATE SCHEMA Test_ExpectException;
GO

CREATE PROCEDURE Test_ExpectException.Test_EmptyExec
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException;',
        @ExpectedMessage = 'Expected an exception to be raised.';
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
    EXEC tSQLt.ExpectException 'Divide by zero error encountered.'; SELECT 1/0 A INTO #Fail;
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

CREATE PROCEDURE Test_ExpectException.Test_GoodExpectedSeverity
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedSeverity = 16; SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_BadExpectedSeverity
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException @ExpectedSeverity = -1; SELECT 1/0 A INTO #Fail;',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedSeverity:<-1>. ActualSeverity:<16>.';
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_GoodExpectedState
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedState = 1; SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_BadExpectedState
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException @ExpectedState = -1; SELECT 1/0 A INTO #Fail;',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedState:<-1>. ActualState:<1>.';
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_GoodExpectedErrorNumber
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedErrorNumber = 8134; SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_BadExpectedErrorNumber
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException @ExpectedErrorNumber = -1; SELECT 1/0 A INTO #Fail;',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedErrorNumber:<-1>. ActualErrorNumber:<8134>.';
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_GoodExpectedMessagePattern
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'Divide by % error encountered.'; SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_BadExpectedMessagePattern
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException @ExpectedMessagePattern = ''Bad error message %''; SELECT 1/0 A INTO #Fail;',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedMessagePattern:<Bad error message %>. ActualMessage:<Divide by zero error encountered.>.';
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_GoodAllExpected
AS
BEGIN
    EXEC tSQLt.ExpectException
        @ExpectedMessage = 'Divide by zero error encountered.',
        @ExpectedSeverity = 16,
        @ExpectedState = 1,
        @ExpectedMessagePattern = 'Divide by % error encountered.',
        @ExpectedErrorNumber = 8134;

    SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_GoodSelectWithSomeExpected
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectException @ExpectedMessagePattern = ''Divide by %'', @ExpectedSeverity = 16, @ExpectedState = 1, @ExpectedErrorNumber = 8134; SELECT 1.0 A INTO #Fail;',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedSeverity:<16>. ExpectedState:<1>. ExpectedMessagePattern:<Divide by %>. ExpectedErrorNumber:<8134>.';
END;
GO