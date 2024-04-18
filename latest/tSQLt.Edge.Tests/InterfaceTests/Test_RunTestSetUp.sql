CREATE SCHEMA Test_RunTestSetUp;
GO

CREATE PROCEDURE Test_RunTestSetUp.SetUp
AS
BEGIN
    EXEC ('CREATE TABLE dbo.SetUpTable (Id INT)');
END;
GO

CREATE PROCEDURE Test_RunTestSetUp.Test_SetUpWasFiredBeforeTestRun
AS
BEGIN
    IF OBJECT_ID ('dbo.SetUpTable', 'U') IS NULL
    BEGIN
        EXEC tSQLt.Fail 'dbo.SetUpTable should exists.';
    END
END;
GO