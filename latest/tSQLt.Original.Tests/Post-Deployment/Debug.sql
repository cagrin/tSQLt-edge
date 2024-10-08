PRINT 'Creating SqlProcedure [tSQLt].[Debug]...'
GO
CREATE PROCEDURE tSQLt.Debug
AS
BEGIN
    DECLARE @AlterNewTestClass NVARCHAR(MAX) =
'
ALTER PROCEDURE tSQLt.NewTestClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = ''CREATE SCHEMA '' + @ClassName;
    EXEC sp_executesql @Command;
END;
';
    EXEC (@AlterNewTestClass);

    DECLARE @AlterFail NVARCHAR(MAX) =
'
ALTER PROCEDURE tSQLt.Fail
    @Message0 NVARCHAR(MAX) = '''',
    @Message1 NVARCHAR(MAX) = '''',
    @Message2 NVARCHAR(MAX) = '''',
    @Message3 NVARCHAR(MAX) = '''',
    @Message4 NVARCHAR(MAX) = '''',
    @Message5 NVARCHAR(MAX) = '''',
    @Message6 NVARCHAR(MAX) = '''',
    @Message7 NVARCHAR(MAX) = '''',
    @Message8 NVARCHAR(MAX) = '''',
    @Message9 NVARCHAR(MAX) = ''''
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = ''tSQLt.Internal_FailDebug'';
    EXEC @Command
    @Message0 = @Message0,
    @Message1 = @Message1,
    @Message2 = @Message2,
    @Message3 = @Message3,
    @Message4 = @Message4,
    @Message5 = @Message5,
    @Message6 = @Message6,
    @Message7 = @Message7,
    @Message8 = @Message8,
    @Message9 = @Message9;
END;
';
    EXEC (@AlterFail);

    EXEC ('DROP PROCEDURE [ApplyConstraintTests].[test ApplyConstraint calls tSQLt.Private_MarktSQLtTempObject on new check constraints]');
    EXEC ('DROP PROCEDURE [ApplyConstraintTests].[test ApplyConstraint calls tSQLt.Private_MarktSQLtTempObject on new foreign key]');
    EXEC ('DROP PROCEDURE [ApplyConstraintTests].[test ApplyConstraint calls tSQLt.Private_MarktSQLtTempObject on new primary key]');
    EXEC ('DROP PROCEDURE [ApplyConstraintTests].[test ApplyConstraint calls tSQLt.Private_MarktSQLtTempObject on new unique key]');

    EXEC ('DROP PROCEDURE [ApplyTriggerTests].[test ApplyTrigger calls tSQLt.Private_MarktSQLtTempObject on new check constraints]');

    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test all unsupported 2008 data types]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test all unsupported data types]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test can handle byte ordered comparable CLR data type]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test can handle hierarchyid data type]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test multiple rows with multiple mismatching rows]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test RC table is created in the tSQLt schema]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test RC table is marked as tSQLt.IsTempObject]');

    EXEC ('DROP PROCEDURE [tSQLt_test_AssertResultSetsHaveSameMetaData].[test AssertResultSetsHaveSameMetaData fails when one result set has no rows for versions before SQL Server 2012]');

    EXEC ('DROP PROCEDURE [ExpectExceptionTests].[test a single ExpectNoException can be followed by a single ExpectException]'); --todo
    EXEC ('DROP PROCEDURE [ExpectExceptionTests].[test fails if called more then once]'); --todo
    EXEC ('DROP PROCEDURE [ExpectExceptionTests].[test ExpectException reports TestEndTime when failing]');
    EXEC ('DROP PROCEDURE [ExpectExceptionTests].[test ExpectException reports TestEndTime when passing]');

    EXEC ('DROP PROCEDURE [ExpectNoExceptionTests].[test a ExpectNoException cannot follow an ExpectException]');
    EXEC ('DROP PROCEDURE [ExpectNoExceptionTests].[test fails if called more then once]');
    EXEC ('DROP PROCEDURE [ExpectNoExceptionTests].[test tSQLt.ExpectNoException includes error information in fail message ]');

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
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors if function is a SVF and @FakeDataSource is used]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when fakee is not a function]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when function is ITVF and fake is not a function]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when function is ITVF and fake is SVF]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when function is MSTVF and fake is not a function]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when function is MSTVF and fake is SVF]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when function is SVF and fake is ITVF]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when function is SVF and fake is MSTVF]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when function is SVF and fake is not a function]'); --todo

    EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable calls tSQLt.Private_MarktSQLtTempObject on new object]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable doesn''t produce output]');
    EXEC ('DROP PROCEDURE [FakeTableTests].[test FakeTable works if new name of original table requires quoting]');

    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test calls original procedure with cursor parameters if @CallOriginal = 1]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test new Procedure Spy is marked as tSQLt.IsTempObject]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test new SpyProcedureLog table is marked as tSQLt.IsTempObject]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test Private_CreateProcedureSpy does create spy when @LogTableName is NULL]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test Private_GenerateCreateProcedureSpyStatement does not create log table when @LogTableName is NULL]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure calls tSQLt.Private_MarktSQLtTempObject on new objects]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure calls tSQLt.Private_RenameObjectToUniqueName on original proc]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure can have a cursor output parameter]');
    EXEC ('DROP PROCEDURE [SpyProcedureTests].[test SpyProcedure fails with error if spyee has more than 1020 parameters]'); --todo
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