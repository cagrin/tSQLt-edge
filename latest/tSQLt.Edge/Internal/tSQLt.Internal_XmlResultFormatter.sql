CREATE PROCEDURE tSQLt.Internal_XmlResultFormatter
AS
BEGIN
    DECLARE @Result XML =
(
    SELECT
        [@id] = ROW_NUMBER() OVER(ORDER BY Id),
        [@name],
        [@tests],
        [@errors],
        [@failures],
        [@skipped],
        [@timestamp],
        [@time],
        [@hostname] = @@SERVERNAME,
        [@package] = 'tSQLt',
        (
            SELECT NULL FOR XML PATH('properties'), TYPE
        ),
        (
            SELECT
                [@classname] = Class,
                [@name] = TestCase,
                [@time] = CAST(DATEDIFF(MILLISECOND, TestStartTime, TestEndTime) / 1000.0 AS DECIMAL(12,4)),
                (
                    SELECT
                        [@message] = F.Msg,
                        [@type] = 'tSQLt.Fail'
                    FROM tSQLt.TestResult F
                    WHERE F.Id = T.Id
                    AND F.Msg IS NOT NULL
                    FOR XML PATH('failure'), TYPE
                )
            FROM tSQLt.TestResult T
            WHERE T.Class = C.Class
            AND Result IS NOT NULL
            FOR XML PATH('testcase'), TYPE
        ),
        (
            SELECT NULL FOR XML PATH('system-out'), TYPE
        ),
        (
            SELECT NULL FOR XML PATH('system-err'), TYPE
        )
    FROM
    (
        SELECT
            Id = MIN(Id),
            Class,
            [@name] = Class,
            [@tests] = COUNT(1),
            [@errors] = 0,
            [@failures] = SUM(CASE WHEN Result = 'Failure' THEN 1 ELSE 0 END),
            [@skipped] = 0,
            [@timestamp] = CAST(MIN(TestStartTime) AS DATETIME2(0)),
            [@time] = CAST(DATEDIFF(MILLISECOND, MIN(TestStartTime), MAX(TestEndTime)) / 1000.0 AS DECIMAL(12,4))
        FROM tSQLt.TestResult
        WHERE Result IS NOT NULL
        GROUP BY Class
    ) C
    FOR XML PATH('testsuite'), ROOT('testsuites')
);

    SELECT CAST(@Result AS XML);
END;
GO