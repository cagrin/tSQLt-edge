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