CREATE SCHEMA Test_Extensions;
GO

CREATE PROCEDURE Test_Extensions.AssertTestFails
    @TestName NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX)
AS
BEGIN
     DECLARE @ErrorMessage NVARCHAR(MAX);

     DECLARE @TranName CHAR(32); EXEC tSQLt.Private_GetNewTranName @TranName OUTPUT;

     EXEC tSQLt.Private_Run @TestName, @TranName, @ErrorMessage OUTPUT;

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

CREATE PROCEDURE Test_Extensions.FakeObjectType
    @ObjectName SYSNAME,
    @FakeType CHAR(2)
AS
BEGIN
    DECLARE @System_Objects tSQLt.System_ObjectsType
    INSERT INTO @System_Objects
    EXEC tSQLt.System_Objects

    SELECT * INTO dbo.FakeSystemObjects FROM @System_Objects;

    UPDATE dbo.FakeSystemObjects SET [type] = @FakeType WHERE [object_id] = OBJECT_ID(@ObjectName)

    EXEC tSQLt.SpyProcedure 'tSQLt.System_Objects', @CommandToExecute = 'SELECT * FROM dbo.FakeSystemObjects'
END;
GO