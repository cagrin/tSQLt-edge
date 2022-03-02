CREATE SCHEMA Test_AssertEquals;
GO

CREATE PROCEDURE Test_AssertEquals.Test_HelloHallo
AS
BEGIN
    -- True
    EXEC tSQLt.AssertEquals 'hallo', 'hallo';
    EXEC tSQLt.AssertEquals NULL, NULL;

    -- False
    DECLARE @Expected NVARCHAR(MAX), @Actual NVARCHAR(MAX);
    BEGIN TRY
        EXEC tSQLt.AssertEquals 'hello', 'hallo';
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertEquals failed. Expected:<hello>. Actual:<hallo>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
    BEGIN TRY
        EXEC tSQLt.AssertEquals 'hello', NULL;
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertEquals failed. Expected:<hello>. Actual:<(null)>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
END;
GO

CREATE PROCEDURE Test_AssertEquals.Test_Numbers
AS
BEGIN
    -- True
    EXEC tSQLt.AssertEquals 5, 5;
    EXEC tSQLt.AssertEquals 3.14, 3.14;

    -- False
    DECLARE @Expected NVARCHAR(MAX), @Actual NVARCHAR(MAX);
    BEGIN TRY
        EXEC tSQLt.AssertEquals 5, 6;
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertEquals failed. Expected:<5>. Actual:<6>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
    BEGIN TRY
        EXEC tSQLt.AssertEquals 3.14, 3.141;
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertEquals failed. Expected:<3.14>. Actual:<3.141>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
END;
GO