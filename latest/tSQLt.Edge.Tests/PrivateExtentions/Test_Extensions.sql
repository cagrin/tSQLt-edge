CREATE SCHEMA Test_Extensions;
GO

CREATE PROCEDURE Test_Extensions.AssertTestFails
    @TestName NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        EXEC tSQLt.Private_Run @TestName;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @ExpectedMessage, @ErrorMessage;
    END CATCH

    IF @ErrorMessage IS NULL
        EXEC tSQLt.Fail 'Test_Extensions.AssertTestFails failed.';
END;
GO