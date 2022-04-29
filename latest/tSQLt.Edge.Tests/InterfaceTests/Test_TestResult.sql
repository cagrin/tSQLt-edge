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
        Result = 'Success',
        Msg = NULL
    INTO #Expected

    SELECT
        Class,
        TestCase,
        Result,
        Msg
    INTO #Actual
    FROM tSQLt.TestResult;

    EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END;
GO

CREATE PROCEDURE Test_TestResult.Test_InternalRunNotFailed
AS
BEGIN
    EXEC('CREATE SCHEMA TestSchema;');
    EXEC('CREATE TABLE TestSchema.TestTable(Column1 INT);');
    EXEC('CREATE PROCEDURE TestSchema.TestCase1 AS EXEC tSQLt.AssertObjectDoesNotExist ''TestSchema.TestTable'';');
    EXEC('CREATE PROCEDURE TestSchema.TestCase2 AS EXEC tSQLt.AssertObjectDoesNotExist ''TestSchema.FakeTable'';');
    EXEC('CREATE PROCEDURE TestSchema.TestCase3 AS EXEC tSQLt.AssertObjectExists ''TestSchema.MissedTestTable'';');

    BEGIN TRY
        EXEC tSQLt.Run 'TestSchema';
    END TRY
    BEGIN CATCH
        EXEC tSQLt.Fail 'EXEC tSQLt.Run ''TestSchema'' should not failed.';
    END CATCH

    SELECT
        Class = 'TestSchema', TestCase = 'TestCase1',
        Result = 'Failure', Msg = 'tSQLt.AssertObjectDoesNotExist failed. Object:<TestSchema.TestTable> does exist.'
    INTO #Expected
    UNION ALL
    SELECT
        Class = 'TestSchema', TestCase = 'TestCase2',
        Result = 'Success', Msg = NULL
    UNION ALL
    SELECT
        Class = 'TestSchema', TestCase = 'TestCase3',
        Result = 'Failure', Msg = 'tSQLt.AssertObjectExists failed. Object:<TestSchema.MissedTestTable> does not exist.'

    SELECT
        Class, TestCase,
        Result, Msg
    INTO #Actual
    FROM tSQLt.TestResult;

    EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END;
GO