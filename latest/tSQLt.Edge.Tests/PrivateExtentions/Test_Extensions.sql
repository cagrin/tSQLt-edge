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
    DECLARE @CommandToExecute NVARCHAR(MAX) = CONCAT
    (
        'IF @ObjectName = ''', @ObjectName, '''',
        ' BEGIN',
        ' SET @ObjectType = ''', @FakeType, '''',
        ' RETURN',
        ' END'
    )

    EXEC tSQLt.SpyProcedure 'tSQLt.Private_GetObjectType', @CommandToExecute, @CallOriginal = 1
END;
GO