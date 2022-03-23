CREATE SCHEMA Test_ExpectNoException;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_EmptyExec
AS
BEGIN
    EXEC tSQLt.ExpectNoException;
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Private_GoodSelect
AS
BEGIN
    EXEC tSQLt.ExpectNoException;

    SELECT 1.0 A INTO #Good;
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Private_FailSelect
AS
BEGIN
    EXEC tSQLt.ExpectNoException;

    SELECT 1/0 A INTO #Fail;
END;
GO

CREATE PROCEDURE Test_ExpectNoException.Test_FailSelect
AS
BEGIN
    BEGIN TRY
        EXEC tSQLt.Private_Run 'Test_ExpectNoException.Private_FailSelect';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString 'Expected no exception to be raised. ErrorMessage:<Divide by zero error encountered.>.', @ErrorMessage;
    END CATCH
END;
GO