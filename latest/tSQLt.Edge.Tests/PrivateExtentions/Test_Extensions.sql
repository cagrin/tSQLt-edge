CREATE SCHEMA Test_Extensions;
GO

CREATE PROCEDURE Test_Extensions.AssertTestFails
    @TestName NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX)
AS
BEGIN
     DECLARE @ErrorMessage NVARCHAR(MAX);

     EXEC tSQLt.Private_Run @TestName, @ErrorMessage OUTPUT;

     EXEC tSQLt.AssertEqualsString @ExpectedMessage, @ErrorMessage;
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