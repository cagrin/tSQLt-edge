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

CREATE PROCEDURE Test_Extensions.AssertCommandFails
    @Command NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX)
AS
BEGIN
    SET @Command = CONCAT_WS
    (
        ' ',
        'CREATE PROCEDURE', 'dbo.TestCommand',
        'AS',
        'BEGIN',
            @Command,
        'END;'
    );
    EXEC (@Command);

    EXEC Test_Extensions.AssertTestFails 'dbo.TestCommand', @ExpectedMessage;
END;
GO