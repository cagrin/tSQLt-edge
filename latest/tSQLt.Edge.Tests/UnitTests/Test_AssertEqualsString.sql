CREATE SCHEMA Test_AssertEqualsString;
GO

CREATE PROCEDURE Test_AssertEqualsString.Test_HelloHallo
AS
BEGIN
    -- True
    EXEC tSQLt.AssertEqualsString 'hallo', 'hallo';
    EXEC tSQLt.AssertEqualsString NULL, NULL;

    -- False
    DECLARE @Expected NVARCHAR(MAX), @Actual NVARCHAR(MAX);
    BEGIN TRY
        EXEC tSQLt.AssertEqualsString 'hello', 'hallo';
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertEqualsString failed. Expected:<hello>. Actual:<hallo>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
    BEGIN TRY
        EXEC tSQLt.AssertEqualsString 'hello', NULL;
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertEqualsString failed. Expected:<hello>. Actual:<(null)>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
END;
GO