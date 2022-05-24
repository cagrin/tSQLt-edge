CREATE PROC tSQLt_testutil.AssertFailMessageLike
    @Command NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX),
    @Message0 VARCHAR(MAX) = NULL,
    @Message1 VARCHAR(MAX) = NULL,
    @Message2 VARCHAR(MAX) = NULL,
    @Message3 VARCHAR(MAX) = NULL,
    @Message4 VARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @ExpectedMessagePattern NVARCHAR(MAX) = '% %'; -- @ExpectedMessage
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = @ExpectedMessagePattern;
    EXEC (@Command);
END;
GO

CREATE PROC tSQLt_testutil.AssertFailMessageEquals
    @Command NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX),
    @Message0 VARCHAR(MAX) = NULL,
    @Message1 VARCHAR(MAX) = NULL,
    @Message2 VARCHAR(MAX) = NULL,
    @Message3 VARCHAR(MAX) = NULL,
    @Message4 VARCHAR(MAX) = NULL
AS
BEGIN
    EXEC tSQLt.ExpectException @ExpectedMessage;
    EXEC (@Command);
END;
GO

CREATE PROC tSQLt_testutil.assertFailCalled
    @Command NVARCHAR(MAX),
    @Message VARCHAR(MAX) = NULL
AS
BEGIN
    EXEC tSQLt.ExpectException;
    EXEC (@Command);
END;
GO

CREATE PROC tSQLt_testutil.AssertTestFails
    @TestName NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX) = NULL
AS
BEGIN
     DECLARE @ErrorMessage NVARCHAR(MAX);
     DECLARE @TranName CHAR(32); EXEC tSQLt.Private_GetNewTranName @TranName OUTPUT;
     EXEC tSQLt.Private_Run @TestName, @TranName, @ErrorMessage OUTPUT;
     EXEC tSQLt.AssertNotEqualsString NULL, @ErrorMessage; -- @ExpectedMessage
END;
GO