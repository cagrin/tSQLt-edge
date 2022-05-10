CREATE SCHEMA Test_ResultLog;
GO

CREATE PROCEDURE Test_ResultLog.Test_SuccessTest
AS
BEGIN
    EXEC tSQLt.FakeTable 'tSQLt.TestResult';
    INSERT INTO tSQLt.TestResult (Result) VALUES ('Success');

    CREATE TABLE #Expected (Failed INT, Passed INT);
    INSERT INTO #Expected (Failed, Passed) VALUES (0, 1);

    CREATE TABLE #Actual (Failed INT, Passed INT);
    INSERT INTO #Actual
    EXEC tSQLt.Private_ResultLog;

    EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END;
GO

CREATE PROCEDURE Test_ResultLog.Test_FailureTest
AS
BEGIN
    EXEC tSQLt.FakeTable 'tSQLt.TestResult';
    INSERT INTO tSQLt.TestResult (Result) VALUES ('Failure');

    CREATE TABLE #Actual (Column1 NVARCHAR(MAX), Column2 NVARCHAR(MAX));
    INSERT INTO #Actual
    EXEC tSQLt.Private_ResultLog;

    DECLARE @Actual INT = (SELECT COUNT(1) FROM #Actual)

    EXEC tSQLt.AssertEquals 2, @Actual;
END;
GO