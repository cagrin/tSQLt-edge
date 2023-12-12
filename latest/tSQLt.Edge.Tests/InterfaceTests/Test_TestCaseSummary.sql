CREATE SCHEMA Test_TestCaseSummary;
GO

CREATE PROCEDURE Test_TestCaseSummary.Test_ResultSet
AS
BEGIN
    CREATE TABLE #Expected
    (
        Msg NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS,
        Cnt INT NOT NULL,
        SuccessCnt INT NOT NULL,
        SkippedCnt INT NOT NULL,
        FailCnt INT NOT NULL,
        ErrorCnt INT NOT NULL
    );

    EXEC tSQLt.AssertResultSetsHaveSameMetaData 'SELECT * FROM #Expected', 'SELECT * FROM tSQLt.TestCaseSummary()';
END;
GO