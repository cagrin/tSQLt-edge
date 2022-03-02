CREATE SCHEMA Test_AssertNotEquals;
GO

CREATE PROCEDURE Test_AssertNotEquals.Test_HelloHallo
AS
BEGIN
    -- True
    EXEC tSQLt.AssertNotEquals 'hello', 'hallo';
    EXEC tSQLt.AssertNotEquals 'hello', NULL;

    -- False
    DECLARE @Expected NVARCHAR(MAX), @Actual NVARCHAR(MAX);
    BEGIN TRY
        EXEC tSQLt.AssertNotEquals 'hello', 'hello';
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertNotEquals failed. Expected any value except:<hello>. Actual:<hello>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
    BEGIN TRY
        EXEC tSQLt.AssertNotEquals NULL, NULL;
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertNotEquals failed. Expected any value except:<(null)>. Actual:<(null)>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
END;
GO

CREATE PROCEDURE Test_AssertNotEquals.Test_Numbers
AS
BEGIN
    -- True
    EXEC tSQLt.AssertNotEquals 5, 6;
    EXEC tSQLt.AssertNotEquals 3.14, 3.141;

    -- False
    DECLARE @Expected NVARCHAR(MAX), @Actual NVARCHAR(MAX);
    BEGIN TRY
        EXEC tSQLt.AssertNotEquals 5, 5;
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertNotEquals failed. Expected any value except:<5>. Actual:<5>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
    BEGIN TRY
        EXEC tSQLt.AssertNotEquals 3.14, 3.14;
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertNotEquals failed. Expected any value except:<3.14>. Actual:<3.14>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
END;
GO