CREATE SCHEMA Test_XmlResultFormatter;
GO

CREATE PROCEDURE Test_XmlResultFormatter.Test_XmlResultIsNotNull
AS
BEGIN
    CREATE TABLE #XmlResult (Result XML)
    INSERT INTO #XmlResult
    EXEC tSQLt.XmlResultFormatter;

    DECLARE @Actual INT = (SELECT COUNT(1) FROM #XmlResult WHERE Result IS NOT NULL);
    EXEC tSQLt.AssertEquals 1, @Actual;
END;
GO

CREATE PROCEDURE Test_XmlResultFormatter.Test_XmlResultLooksLikeValid
AS
BEGIN
    CREATE TABLE #XmlResult (Result XML)
    INSERT INTO #XmlResult
    EXEC tSQLt.XmlResultFormatter;

    DECLARE @Result XML = (SELECT Result FROM #XmlResult)

    DECLARE @Actual NVARCHAR(MAX) = CAST(@Result AS NVARCHAR(MAX));
    DECLARE @ExpectedPattern NVARCHAR(MAX) = '<testsuites%testsuite%properties%testcase%system-out%system-err%testsuite%testsuites>';

    EXEC tSQLt.AssertLike @ExpectedPattern, @Actual;
END;
GO