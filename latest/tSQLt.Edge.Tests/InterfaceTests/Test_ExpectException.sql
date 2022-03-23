CREATE SCHEMA Test_ExpectException;
GO

CREATE PROCEDURE Test_ExpectException.Private_EmptyExec
AS
BEGIN
    EXEC tSQLt.ExpectException;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_EmptyExec
AS
BEGIN
    BEGIN TRY
        EXEC tSQLt.Private_Run 'Test_ExpectException.Private_EmptyExec';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString 'Expected an exception to be raised. ExpectedMessage: (null)', @ErrorMessage;
    END CATCH
END;
GO

CREATE PROCEDURE Test_ExpectException.Private_GoodSelect
AS
BEGIN
    EXEC tSQLt.ExpectException 'Error message.';

    SELECT 1.0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_GoodSelect
AS
BEGIN
    BEGIN TRY
        EXEC tSQLt.Private_Run 'Test_ExpectException.Private_GoodSelect';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString 'Expected an exception to be raised. ExpectedMessage:<Error message.>.', @ErrorMessage;
    END CATCH
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_FailSelect
AS
BEGIN
    EXEC tSQLt.ExpectException 'Divide by zero error encountered.';

    SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Private_BadErrorMessage
AS
BEGIN
    EXEC tSQLt.ExpectException 'Bad error message.';

    SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectException.Test_BadErrorMessage
AS
BEGIN
    BEGIN TRY
        EXEC tSQLt.Private_Run 'Test_ExpectException.Private_BadErrorMessage';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString 'Expected an exception to be raised. ExpectedMessage:<Bad error message.>. ActualMessage:<Divide by zero error encountered.>.', @ErrorMessage;
    END CATCH
END;
GO