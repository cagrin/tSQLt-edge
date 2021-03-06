CREATE FUNCTION tSQLt.TestCaseSummary()
RETURNS @Result TABLE
(
    Msg NVARCHAR(MAX),
    Cnt INT NOT NULL,
    SuccessCnt INT NOT NULL,
    SkippedCnt INT NOT NULL,
    FailCnt INT NOT NULL,
    ErrorCnt INT NOT NULL
)
AS
BEGIN
    INSERT INTO @Result
    SELECT
        Msg = CONCAT_WS
        (
            ' ',
            'Test Case Summary:',
            CAST(Cnt AS NVARCHAR), 'test case(s) executed,',
            CAST(SuccessCnt AS NVARCHAR), 'succeeded,',
            CAST(SkippedCnt AS NVARCHAR), 'skipped,',
            CAST(FailCnt AS NVARCHAR), 'failed,',
            CAST(ErrorCnt AS NVARCHAR), 'errored.'
        ),
        Cnt,
        SuccessCnt,
        SkippedCnt,
        FailCnt,
        ErrorCnt
    FROM
    (
        SELECT
            Cnt = COUNT(1),
            SuccessCnt = ISNULL(SUM(CASE WHEN Result = 'Success' THEN 1 ELSE 0 END), 0),
            SkippedCnt = ISNULL(SUM(CASE WHEN Result = 'Skipped' THEN 1 ELSE 0 END), 0),
            FailCnt = ISNULL(SUM(CASE WHEN Result = 'Failure' THEN 1 ELSE 0 END), 0),
            ErrorCnt = ISNULL(SUM(CASE WHEN Result = 'Error' THEN 1 ELSE 0 END), 0)
        FROM tSQLt.TestResult
    ) A
    RETURN
END;