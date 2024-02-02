PRINT 'Creating SqlProcedure [tSQLt].[Debug]...'
GO
CREATE OR ALTER PROCEDURE tSQLt.Debug
AS
BEGIN

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

    DECLARE @AlterExpectException NVARCHAR(MAX) =
'
CREATE PROCEDURE tSQLt.ExpectException
    @ExpectedMessage NVARCHAR(MAX) = NULL,
    @ExpectedSeverity INT = NULL,
    @ExpectedState INT = NULL,
    @Message NVARCHAR(MAX) = NULL,
    @ExpectedMessagePattern NVARCHAR(MAX) = NULL,
    @ExpectedErrorNumber INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = ''tSQLt.Internal_ExpectExceptionDebug'';
    EXEC @Command
    @ExpectedMessage = @ExpectedMessage,
    @ExpectedSeverity = @ExpectedSeverity,
    @ExpectedState = @ExpectedState,
    @Message = @Message,
    @ExpectedMessagePattern = @ExpectedMessagePattern,
    @ExpectedErrorNumber = @ExpectedErrorNumber;
END;
';

    EXEC sp_rename 'tSQLt.ExpectException', 'Internal_ExpectException';
    EXEC (@AlterExpectException);

    -- Setup
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_ApplyConstraint] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_ApplyTrigger] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertEmptyTable] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertEquals] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertEqualsString] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertEqualsTable] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertEqualsTableSchema] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertLike] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertNotEquals] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertObjectDoesNotExist] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertObjectExists] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertResultSetsHaveSameMetaData] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertStringIn] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_ExpectException] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_ExpectNoException] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_Fail] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_FakeFunction] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_FakeTable] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_RemoveObject] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_RemoveObjectIfExists] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_SpyProcedure] TO [tSQLt.TestClass];')

    -- Failure
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_ErrorMessage]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_FirstTableHasTwinRows]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_FirstTableIsNotEmpty]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_FloatLossOfPrecision]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_LowDate]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_SecondTableHasTwinRows]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_SecondTableIsNotEmpty]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_TempTables_ActualNotExists]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_TempTables_ExpectedNotExists]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_UncomparableDataTypes]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTableSchema].[Test_DifferentColumnCollation]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTableSchema].[Test_DifferentColumnNames]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTableSchema].[Test_DifferentColumnNullable]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTableSchema].[Test_ErrorMessage]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTableSchema].[Test_TempTables_ActualNotExists]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTableSchema].[Test_TempTables_ExpectedNotExists]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTableSchema].[Test_TempTablesFail]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTableSchema].[Test_TempTablesOptionsFail]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTableSchema].[Test_UserTypeWithDifferentSchema]');
    EXEC ('DROP PROCEDURE [Test_AssertResultSetsHaveSameMetaData].[Test_ActualCommandIsNull]');
    EXEC ('DROP PROCEDURE [Test_AssertResultSetsHaveSameMetaData].[Test_ExpectedCommandIsNull]');
    EXEC ('DROP PROCEDURE [Test_AssertResultSetsHaveSameMetaData].[Test_SelectDivideBy0]');
    EXEC ('DROP PROCEDURE [Test_AssertResultSetsHaveSameMetaData].[Test_SelectIntBigint]');
    EXEC ('DROP PROCEDURE [Test_AssertResultSetsHaveSameMetaData].[Test_SelectMissingTemp]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_ComputedColumnWithScalarFunctionFailed]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_Failed_When_Procedure]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_ScalarFunction_FakeFunctionIsNull]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_ScalarFunction_FunctionIsNull]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_SchemaAndTableNameNotExists]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_SchemaAndTableReversedNameNotExists]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_TableNameIsNull]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_TableNameNotExists]');
    EXEC ('DROP PROCEDURE [Test_FakeTable].[Test_CanFakeTempTable]');
    EXEC ('DROP PROCEDURE [Test_FakeTable].[Test_CannotFakeSynonymForProcedure]');
    EXEC ('DROP PROCEDURE [Test_FakeTable].[Test_CannotFakeTableAndViewWithSchemabinding]');
    EXEC ('DROP PROCEDURE [Test_RemoveObject].[Test_Table_NotExists]');
    EXEC ('DROP PROCEDURE [Test_RemoveObject].[Test_TempTable]');
    EXEC ('DROP PROCEDURE [Test_SpyProcedure].[Test_ProcedureDoesNotExist]');

    -- Error
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_XmlComparison]');
    EXEC ('DROP PROCEDURE [Test_AssertEqualsTable].[Test_XmlComparisonToString]');
    EXEC ('DROP PROCEDURE [Test_AssertStringIn].[Test_Null_Null]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_BadErrorMessage]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_BadErrorMessageWithMessage]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_BadExpectedErrorNumber]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_BadExpectedMessagePattern]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_BadExpectedSeverity]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_BadExpectedState]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_EmptyExec]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_GoodSelect]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_GoodSelectWithMessage]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_GoodSelectWithNoneExpected]');
    EXEC ('DROP PROCEDURE [Test_ExpectException].[Test_GoodSelectWithSomeExpected]');
    EXEC ('DROP PROCEDURE [Test_ExpectNoException].[Test_FailSelect]');
    EXEC ('DROP PROCEDURE [Test_ExpectNoException].[Test_FailSelectWithMessage]');
    EXEC ('DROP PROCEDURE [Test_ExpectNoException].[Test_GoodAndFailSelectButFirstFail]');
    EXEC ('DROP PROCEDURE [Test_ExpectNoException].[Test_GoodAndFailSelectButSecondFail]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_Can_Fake_Assembly_CLR_ScalarFunction]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_Can_Fake_Assembly_CLR_TableValuedFunction]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_Failed_When_UnsuportedFunctionType]');
    EXEC ('DROP PROCEDURE [Test_FakeTable].[Test_CanFakeExternalTable]');
    EXEC ('DROP PROCEDURE [Test_FakeTable].[Test_CanPreserveNotNull]');
    EXEC ('DROP PROCEDURE [Test_RemoveObject].[Test_NewNameIsEmpty]');
    EXEC ('DROP PROCEDURE [Test_RemoveObject].[Test_NewNameIsNotEmpty]');

    -- Unsupported
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_PrimaryKeyApplied_WithDescendingKey]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_ExternalCheckConstraintApplied]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_ExternalForeignKeyApplied]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_ExternalPrimaryKeyApplied]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_ExternalUniqueConstraintApplied]');
    EXEC ('DROP PROCEDURE [Test_ApplyTrigger].[Test_IsExternalTriggeredAfterFakeTableAndApplyTrigger]');
    EXEC ('DROP PROCEDURE [Test_AssertEmptyTable].[Test_QuotedEmptyTempTable]');
    EXEC ('DROP PROCEDURE [Test_AssertEmptyTable].[Test_NonEmptyExternalTable]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_ExternalInlineTableValuedFunction]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_ExternalMultiStatementTableValuedFunctionWithP1]');
    EXEC ('DROP PROCEDURE [Test_FakeFunction].[Test_ExternalScalarFunctionWithP1]');
    EXEC ('DROP PROCEDURE [Test_RemoveObject].[Test_ExternalTable]');
    EXEC ('DROP PROCEDURE [Test_RemoveObject].[Test_ExternalTableNewName]');
    EXEC ('DROP PROCEDURE [Test_SpyProcedure].[Test_ExternalProcedure]');
    EXEC ('DROP PROCEDURE [Test_SpyProcedure].[Test_Procedure_Start_End_]');
END;
GO

PRINT 'Running SqlProcedure [tSQLt].[Debug]...'
GO
EXEC tSQLt.Debug
GO