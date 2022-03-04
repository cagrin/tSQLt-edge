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