CREATE PROCEDURE tSQLt.Private_ResultLog
AS
BEGIN
    DECLARE @Failed INT = (SELECT COALESCE(COUNT(1), 0) FROM tSQLt.TestResult WHERE COALESCE(Result, '') = 'Failure');
    DECLARE @Passed INT = (SELECT COALESCE(COUNT(1), 0) FROM tSQLt.TestResult WHERE COALESCE(Result, '') = 'Success');

    SELECT Failed = @Failed, Passed = @Passed

    IF @Failed > 0
        SELECT Name, Msg FROM tSQLt.TestResult WHERE COALESCE(Result, '') = 'Failure'
END;
GO