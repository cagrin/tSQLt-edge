PRINT 'Creating SqlProcedure [tSQLt].[Debug]...'
GO
CREATE PROCEDURE tSQLt.Debug
AS
BEGIN
    DECLARE @AlterExpectException NVARCHAR(MAX) =
'
ALTER PROCEDURE tSQLt.ExpectException
    @ExpectedMessage NVARCHAR(MAX) = NULL,
    @ExpectedSeverity INT = NULL,
    @ExpectedState INT = NULL,
    @Message NVARCHAR(MAX) = NULL,
    @ExpectedMessagePattern NVARCHAR(MAX) = NULL,
    @ExpectedErrorNumber INT = NULL
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = ''tSQLt.Internal_ExpectException'';
    EXEC @Command;
END;
';
    EXEC (@AlterExpectException);

    DECLARE @AlterFakeTable NVARCHAR(MAX) =
'
ALTER PROCEDURE tSQLt.FakeTable
    @TableName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL, --parameter preserved for backward compatibility. Do not use. Will be removed soon.
    @Identity BIT = NULL,
    @ComputedColumns BIT = NULL,
    @Defaults BIT = NULL
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = ''tSQLt.Internal_FakeTableDebug'';
    EXEC @Command
    @TableName = @TableName,
    @SchemaName = @SchemaName,
    @Identity = @Identity,
    @ComputedColumns = @ComputedColumns,
    @Defaults = @Defaults;
END;
';
    EXEC (@AlterFakeTable);

    DECLARE @AlterRemoveObject NVARCHAR(MAX) =
'
ALTER PROCEDURE tSQLt.RemoveObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT,
    @IfExists INT = 0
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = ''tSQLt.Internal_RemoveObjectDebug'';
    EXEC @Command
    @ObjectName = @ObjectName,
    @NewName = @NewName OUTPUT,
    @IfExists = @IfExists;
END;
';
    EXEC (@AlterRemoveObject);

    --EXEC ('DROP PROCEDURE [AssertEmptyTableTests].[test uses tSQLt.TableToText]');

    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test all unsupported 2008 data types]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test all unsupported data types]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test can handle byte ordered comparable CLR data type]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test can handle hierarchyid data type]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test multiple rows with multiple mismatching rows]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test RC table is created in the tSQLt schema]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test RC table is marked as tSQLt.IsTempObject]');

    --EXEC ('DROP PROCEDURE [AssertNotEqualsTests].[test AssertNotEquals should give meaningfull failmessage]');

    EXEC ('DROP PROCEDURE [tSQLt_test_AssertResultSetsHaveSameMetaData].[test AssertResultSetsHaveSameMetaData does not compare hidden columns]'); --todo
    EXEC ('DROP PROCEDURE [tSQLt_test_AssertResultSetsHaveSameMetaData].[test AssertResultSetsHaveSameMetaData fails when one result set has no rows for versions before SQL Server 2012]');

    -- AssertStringInTests.class.sql

    -- ExpectExceptionTests.class.sql --todo

    -- ExpectNoExceptionTests.class.sql --todo

    EXEC ('DROP PROCEDURE [FailTests].[test Fail does not change open tansaction count in case of XACT_STATE = -1]'); --todo
    EXEC ('DROP PROCEDURE [FailTests].[test Fail gives info about cleanup work if transaction state is invalidated]'); --todo
    EXEC ('DROP PROCEDURE [FailTests].[test Fail recreates savepoint if it has to clean up transactions]'); --todo
    EXEC ('DROP PROCEDURE [FailTests].[test Fail rolls back transaction if transaction is unable to be committed]'); --todo

    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake CLR table function using a table as fake data source]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake CLR TVF WITH CLR TVF]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake CLR TVF WITH ITVF]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake CLR TVF with MSTVF]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake ITVF WITH CLR TVF]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake MSTVF WITH CLR TVF]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors if function is a CLR SVF and @FakeDataSource is used]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test Fake can be CLR function]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test Fakee can be CLR function]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test FakeFunction calls tSQLt.Private_MarktSQLtTempObject on new object]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test Private_PrepareFakeFunctionOutputTable returns table with SELECT query]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test Private_PrepareFakeFunctionOutputTable returns table with VALUES]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test tSQLt.Private_GetFullTypeName is used for return type]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test tSQLt.Private_GetFullTypeName is used to build parameter list]');

    EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable calls tSQLt.Private_MarktSQLtTempObject on new object]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable doesn''t produce output]');
    --EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable raises appropriate error if called with NULL parameters]'); --todo
    --EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable raises appropriate error if it was called with a single parameter]'); --todo
    EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable raises appropriate error if schema does not exist]');
    --EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable raises appropriate error if table does not exist]'); --todo
    EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable takes 2 nameless parameters containing schema and table name]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable works if new name of original table requires quoting]'); --todo
    EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable works with two parameters, if they are quoted]'); --todo
    EXEC ('DROP PROCEDURE [FakeTableTests].[test Private_ResolveFakeTableNamesForBackwardCompatibility accepts full name as 1st parm if 2nd parm is null]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test Private_ResolveFakeTableNamesForBackwardCompatibility accepts parms in wrong order]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test Private_ResolveFakeTableNamesForBackwardCompatibility can handle quoted names]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test Private_ResolveFakeTableNamesForBackwardCompatibility returns NULL schema name when table does not exist]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test Private_ResolveFakeTableNamesForBackwardCompatibility returns NULL table name when table does not exist]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test Private_ResolveFakeTableNamesForBackwardCompatibility returns NULLs when table name has special char]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test Private_ResolveFakeTableNamesForBackwardCompatibility returns quoted schema when schema and table provided]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test Private_ResolveFakeTableNamesForBackwardCompatibility returns quoted table when schema and table provided]');

    --EXEC ('DROP PROCEDURE [RemoveObjectTests].[test RemoveObject raises approporate error if object doesn''t exists'']'); --todo

    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test all tSQLt.Run methods call the run method handler]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_RunMethodHandler> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test DefaultResultFormatter is using PrepareTestResultForOutput]'); --tSQLt.AssertObjectExists failed. Object:<tSQLt.Private_PrepareTestResultForOutput> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test FATAL error prevents subsequent tSQLt.Run% calls]'); --tSQLt.NewTestClass is not supported. Use CREATE SCHEMA 'ClassName'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test NullTestResultFormatter prints no results from the tests]'); --Invalid object name 'tSQLt.CaptureOutputLog'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test PrepareTestResultForOutput calculates test duration]'); --Invalid object name 'tSQLt.Private_PrepareTestResultForOutput'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test PrepareTestResultForOutput orders tests appropriately]'); --Invalid object name 'tSQLt.Private_PrepareTestResultForOutput'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Privat_GetCursorForRunNew returns all test classes created after(!) tSQLt.Reset was called]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Privat_GetCursorForRunNew skips dropped classes]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Privat_RunNew calls Private_RunCursor with correct cursor]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_RunCursor> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Private_OutputTestResults uses the TestResultFormatter parameter]'); --Run_Methods_Tests.TemporaryTestResultFormatter did not get called correctly
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Private_Run calls tSQLt.Private_OutputTestResults with passed in TestResultFormatter]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_OutputTestResults> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Private_RunAll calls tSQLt.Private_OutputTestResults with passed in TestResultFormatter]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_OutputTestResults> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Private_RunMethodHandler calls Private_Init before calling ssp]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_Init> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Private_RunMethodHandler defaults @TestResultFormatter to configured Test Result Formatter]'); --Could not find stored procedure 'tSQLt.Private_RenameObjectToUniqueName'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Private_RunMethodHandler passes @TestResultFormatter to ssp]'); --Could not find stored procedure 'tSQLt.Private_RunMethodHandler'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test procedure can be injected to display test results]'); --Could not find stored procedure 'tSQLt.SetTestResultFormatter'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test produces meaningful error when pre and post transactions counts don''t match in NoTransaction test]'); --tSQLt.NewTestClass is not supported. Use CREATE SCHEMA 'ClassName'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test produces meaningful error when pre and post transactions counts don''t match]'); --tSQLt.NewTestClass is not supported. Use CREATE SCHEMA 'ClassName'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Run calls Private_RunMethodHandler correctly]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_RunMethodHandler> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Run executes the SetUp for each test case in test class]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test Run executes the SetUp if called for single test]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test RunAll clears test results between each execution]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test RunAll executes the SetUp for each test case]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test RunAll produces a test case summary]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test RunAll runs all test classes created with NewTestClass when there are multiple tests in each class]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test RunAll runs all test classes created with NewTestClass]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test RunTestClass truncates TestResult table]'); --Could not find stored procedure 'tSQLt.RunTestClass'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test RunWithNullResults calls Run with NullTestResultFormatter]'); --Could not find stored procedure 'tSQLt.RunWithNullResults'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test RunWithNullResults passes NULL as TestName if called without parmameters]'); --Could not find stored procedure 'tSQLt.RunWithNullResults'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test RunWithXmlResults calls Run with XmlResultFormatter]'); --Could not find stored procedure 'tSQLt.RunWithXmlResults'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test RunWithXmlResults passes NULL as TestName if called without parmameters]'); --Could not find stored procedure 'tSQLt.RunWithXmlResults'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test SetUp can be spelled with any casing when using Run with single test]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test SetUp can be spelled with any casing when using Run with TestClass]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test SetUp can be spelled with any casing when using RunAll]'); --Could not find stored procedure 'tSQLt_testutil.RemoveTestClassPropertyFromAllExistingClasses'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Private_Run captures finish time for failing test]'); --tSQLt.DropClass is not supported.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Private_Run captures finish time]'); --tSQLt.DropClass is not supported.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Private_Run captures start time for failing test]'); --tSQLt.DropClass is not supported.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Private_Run captures start time]'); --tSQLt.DropClass is not supported.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Private_Run doesn''t print start and stop info when tSQLt.SetVerbose 0 was called]'); --tSQLt.DropClass is not supported.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Private_Run prints start and stop info when tSQLt.SetVerbose was called]'); --tSQLt.DropClass is not supported.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Run deletes all entries from tSQLt.Run_LastExecution with same SPID]'); --@SchemaName parameter preserved for backward compatibility. Do not use. Will be removed soon.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Run executes all tests in test class when called with class name]'); --tSQLt.DropClass is not supported.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Run executes single test when called with test case name]'); --tSQLt.DropClass is not supported.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Run re-executes single test when called without parameter]'); --tSQLt.DropClass is not supported.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test that tSQLt.Run re-executes testClass when called without parameter]'); --tSQLt.DropClass is not supported.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test the Test Case Summary line is "printed" as error if there are multiple failure and error results]'); --Could not find stored procedure 'tSQLt.SetSummaryError'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test the Test Case Summary line is "printed" as error if there is one error result]'); --Could not find stored procedure 'tSQLt.SetSummaryError'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test the Test Case Summary line is "printed" as error if there is one failure result]'); --Could not find stored procedure 'tSQLt.SetSummaryError'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test the Test Case Summary line is not "printed" as error if there are only skipped results]'); --Could not find stored procedure 'tSQLt.SetSummaryError'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test the Test Case Summary line is not "printed" as error if there are only success and skipped results]'); --Could not find stored procedure 'tSQLt.SetSummaryError'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test the Test Case Summary line is not "printed" as error if there are only success results]'); --Could not find stored procedure 'tSQLt.SetSummaryError'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.Private_InputBuffer does not produce output]'); --Invalid object name 'tSQLt.CaptureOutputLog'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.Private_InputBuffer returns non-empty string]'); --Could not find stored procedure 'tSQLt.Private_InputBuffer'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.Private_RunMethodHandler passes @TestName if ssp has that parameter]'); --Could not find stored procedure 'tSQLt.Private_RenameObjectToUniqueName'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.Run executes a test class even if there is a dbo owned object of the same name]'); --tSQLt.NewTestClass is not supported. Use CREATE SCHEMA 'ClassName'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.Run executes test class with single quotes in name]'); --tSQLt.AssertEqualsTable failed. Expected:<#Expected> has different rowset than Actual:<#Actual>.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.Run executes test with single quotes in class and test names]'); --tSQLt.AssertEqualsTable failed. Expected:<#Expected> has different rowset than Actual:<#Actual>.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.RunAll calls Private_RunMethodHandler with tSQLt.Private_RunAll]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_RunMethodHandler> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.RunAll can handle classes with single quotes]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_RunTestClass> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.RunAll executes tests with single quotes in class and name]'); --FakeTable could not resolve the object name, 'tSQLt.TestClasses'. (When calling tSQLt.FakeTable, avoid the use of the @SchemaName parameter, as it is deprecated.)
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.RunC calls tSQLt.Run with everything after ;-- as @TestName]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_InputBuffer> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.RunC removes leading and trailing spaces from testname]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_InputBuffer> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.RunNew calls Private_RunMethodHandler with tSQLt.Private_RunNew]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_RunMethodHandler> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.RunNew executes test class with single quotes in class and test names]'); --FakeTable could not resolve the object name, 'tSQLt.TestClasses'. (When calling tSQLt.FakeTable, avoid the use of the @SchemaName parameter, as it is deprecated.)
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test tSQLt.RunTestClass executes tests with single quotes in class and name]'); --Could not find stored procedure 'tSQLt.RunTestClass'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test when @Result=Abort an appropriate error message is raised]'); --tSQLt.NewTestClass is not supported. Use CREATE SCHEMA 'ClassName'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test when @Result=FATAL an appropriate error message is raised]'); --tSQLt.NewTestClass is not supported. Use CREATE SCHEMA 'ClassName'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter arranges multiple test cases into testsuites]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter creates <testsuites/> when no test cases in test suite]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter creates testsuite with multiple test elements some skipped]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter creates testsuite with multiple test elements some with failures or errors]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter creates testsuite with multiple test elements some with failures]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter creates testsuite with test element and failure element when there is a failing test]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter creates testsuite with test element when there is a passing test]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter handles even this:   ,/?'''';:[o]]}\|{)(*&^%$#@""]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter includes duration for each test]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter includes other required fields]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter includes start time and total duration per class]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter returns XML that validates against the JUnit test result xsd]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter sets correct counts for skipped tests]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test XmlResultFormatter sets correct counts in testsuite attributes]'); --tSQLt.RemoveObject failed. ObjectName:<tSQLt.Private_PrintXML> does not exist.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test_Run_handles_test_names_with_spaces]'); --Could not find stored procedure 'tSQLt.Private_GetSQLProductMajorVersion'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test_RunTestClass_handles_test_names_with_spaces]'); --Could not find stored procedure 'tSQLt.RunTestClass'.
    EXEC ('DROP PROCEDURE [Run_Methods_Tests].[test_that_a_failing_SetUp_causes_test_to_be_marked_as_failed]'); --tSQLt.DropClass is not supported.

    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test @SpyProcedureOriginalObjectName contains original proc name even if it has single quotes, dots, or spaces]'); --todo
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test @SpyProcedureOriginalObjectName contains original proc name inside spy even if quoting is required]'); --todo
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test @SpyProcedureOriginalObjectName contains original proc name inside spy]'); --todo
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test calls original procedure with cursor parameters if @CallOriginal = 1]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test new Procedure Spy is marked as tSQLt.IsTempObject]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test new SpyProcedureLog table is marked as tSQLt.IsTempObject]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test Private_CreateProcedureSpy does create spy when @LogTableName is NULL]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test Private_GenerateCreateProcedureSpyStatement does not create log table when @LogTableName is NULL]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure calls tSQLt.Private_MarktSQLtTempObject on new objects]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure calls tSQLt.Private_RenameObjectToUniqueName on original proc]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure can have a cursor output parameter]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure fails with error if spyee has more than 1020 parameters]'); --todo
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure handles procedure and schema names with single quotes]'); --todo
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure raises appropriate error if the procedure does not exist]'); --todo
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure raises appropriate error if the procedure name given references another type of object]'); --todo
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure works if spyee has 100 parameters with 8000 bytes each]'); --todo
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure works with CLR procedures]');
END;
GO

PRINT 'Running SqlProcedure [tSQLt].[Debug]...'
GO
EXEC tSQLt.Debug
GO

CREATE SCHEMA Debug;
GO
CREATE PROC Debug.[Test_Coverage]
AS
BEGIN
    DECLARE @Result NVARCHAR(MAX);

    SELECT @Result = [FakeFunctionTests].[An SVF]();

    SELECT @Result = r
    FROM [FakeFunctionTests].[A MSTVF]();
END;
GO

DROP PROCEDURE FailTests.[InvalidateTransaction];
GO