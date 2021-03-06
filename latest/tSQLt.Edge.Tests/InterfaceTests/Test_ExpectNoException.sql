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
    EXEC tSQLt.ExpectNoException; SELECT 1.0 A INTO #Good;
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_FailSelect
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectNoException; SELECT 1/0 A INTO #Fail;',
        @ExpectedMessage = 'Expected no exception to be raised. ErrorMessage:<Divide by zero error encountered.>. ErrorSeverity:<16>. ErrorState:<1>. ErrorNumber:<8134>.';
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_FailSelectWithMessage
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = 'EXEC tSQLt.ExpectNoException ''Message.''; SELECT 1/0 A INTO #Fail;',
        @ExpectedMessage = 'Message. Expected no exception to be raised. ErrorMessage:<Divide by zero error encountered.>. ErrorSeverity:<16>. ErrorState:<1>. ErrorNumber:<8134>.';
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_GoodAndFailSelect
AS
BEGIN
    EXEC tSQLt.ExpectNoException;
    SELECT 1.0 A INTO #Good;

    EXEC tSQLt.ExpectException @ExpectedMessage = 'Divide by zero error encountered.';
    SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_GoodAndFailSelectButFirstFail
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = '
            EXEC tSQLt.ExpectNoException;
            SELECT 1/0 A INTO #Good;

            EXEC tSQLt.ExpectException @ExpectedMessage = ''Divide by zero error encountered.'';
            SELECT 1/0 A INTO #Fail;
        ',
        @ExpectedMessage = 'Expected no exception to be raised. ErrorMessage:<Divide by zero error encountered.>. ErrorSeverity:<16>. ErrorState:<1>. ErrorNumber:<8134>.';
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_GoodAndFailSelectButSecondFail
AS
BEGIN
    EXEC Test_Extensions.AssertCommandFails
        @Command = '
            EXEC tSQLt.ExpectNoException;
            SELECT 1.0 A INTO #Good;

            EXEC tSQLt.ExpectException @ExpectedMessage = ''Divide by zero error encountered.'';
            SELECT 1.0 A INTO #Fail;
        ',
        @ExpectedMessage = 'Expected an exception to be raised. ExpectedMessage:<Divide by zero error encountered.>.';
END;
GO