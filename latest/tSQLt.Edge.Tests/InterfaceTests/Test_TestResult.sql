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

CREATE PROCEDURE Test_TestResult.Test_InternalRunFailed
AS
BEGIN
    EXEC('CREATE SCHEMA TestSchema;');
    EXEC('CREATE TABLE TestSchema.TestTable(Column1 INT);');
    EXEC('CREATE PROCEDURE TestSchema.TestCase AS EXEC tSQLt.AssertObjectDoesNotExist ''TestSchema.TestTable'';');

    BEGIN TRY
        EXEC tSQLt.Run 'TestSchema.TestCase';
    END TRY
    BEGIN CATCH
        EXEC tSQLt.Fail 'EXEC tSQLt.Run ''TestSchema.TestCase'' should not failed.';
    END CATCH

    SELECT
        Class = 'TestSchema',
        TestCase = 'TestCase',
        Result = 'Failure',
        Msg = 'tSQLt.AssertObjectDoesNotExist failed. Object:<TestSchema.TestTable> does exist.'
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