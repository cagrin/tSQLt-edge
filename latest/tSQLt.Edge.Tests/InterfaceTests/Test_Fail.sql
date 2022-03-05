CREATE SCHEMA Test_Fail;
GO

CREATE PROCEDURE Test_Fail.Test_Raiserror
AS
BEGIN
    DECLARE @Expected NVARCHAR(MAX), @Actual NVARCHAR(MAX);
    BEGIN TRY
        EXEC tSQLt.Fail 'Test_Raiserror';
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'Test_Raiserror', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
END;
GO

CREATE PROCEDURE Test_Fail.Test_Raiserror_Message9
AS
BEGIN
    DECLARE @Expected NVARCHAR(MAX), @Actual NVARCHAR(MAX);
    BEGIN TRY
        EXEC tSQLt.Fail 'Test_Raiserror', 'M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8', @Message9 = 'M9';
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'Test_Raiserror M1 M2 M3 M4 M5 M6 M7 M8 M9', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
END;
GO