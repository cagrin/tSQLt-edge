CREATE PROCEDURE tSQLt.Private_ResultLog
AS
BEGIN
    DECLARE @Failed INT = (SELECT ISNULL(COUNT(1), 0) FROM tSQLt.TestResult WHERE Result = 'Failure');
    DECLARE @Passed INT = (SELECT ISNULL(COUNT(1), 0) FROM tSQLt.TestResult WHERE Result = 'Success');

    SELECT Failed = @Failed, Passed = @Passed

    IF @Failed > 0
        SELECT Name, Msg FROM tSQLt.TestResult WHERE Result = 'Failure'
END;
GO