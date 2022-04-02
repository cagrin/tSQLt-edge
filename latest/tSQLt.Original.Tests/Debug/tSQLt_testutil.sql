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
    EXEC tSQLt.ExpectException;
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
    EXEC tSQLt.ExpectException;
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