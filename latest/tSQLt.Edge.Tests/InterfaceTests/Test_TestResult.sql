CREATE SCHEMA Test_TestResult;
GO

CREATE PROCEDURE Test_TestResult.Test_InternalRun
AS
BEGIN
    EXEC('CREATE SCHEMA TestSchema;');
    EXEC('CREATE TABLE TestSchema.TestTable(Column1 INT);');
    EXEC('CREATE PROCEDURE TestSchema.TestCase AS EXEC tSQLt.AssertObjectExists ''TestSchema.TestTable'';');

    EXEC tSQLt.Run 'TestSchema.TestCase';

    SELECT
        Class = 'TestSchema',
        TestCase = 'TestCase',
        Result = 'Success'
    INTO #Expected

    SELECT
        Class,
        TestCase,
        Result
    INTO #Actual
    FROM tSQLt.TestResult;

    EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END;
GO