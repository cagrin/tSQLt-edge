CREATE PROCEDURE tSQLt.Debug
AS
BEGIN
    DECLARE @Private_ProcessErrorMessage NVARCHAR(MAX) =
'
ALTER PROCEDURE tSQLt.Private_ProcessErrorMessage
    @ErrorMessage NVARCHAR(4000) OUTPUT,
    @ErrorSeverity INT,
    @ErrorState INT,
    @ErrorNumber INT
AS
BEGIN
    DECLARE @ExpectException BIT;
    DECLARE @ExpectedNoExceptionMessage NVARCHAR(MAX) = ''Expected no exception to be raised.'';
    DECLARE @ExpectedExceptionMessage NVARCHAR(MAX) = ''Expected an exception to be raised.'';

    SELECT
        @ExpectException  = ExpectException
    FROM #ExpectException

    IF @ExpectException = 0
    BEGIN
        IF @ErrorMessage IS NOT NULL
        BEGIN
            SET @ErrorMessage = @ExpectedNoExceptionMessage
        END
    END

    IF @ExpectException = 1
    BEGIN
        IF @ErrorMessage IS NOT NULL
        BEGIN
            SET @ErrorMessage = NULL;
        END
        ELSE
        BEGIN
            SET @ErrorMessage = @ExpectedExceptionMessage
        END
    END

    DELETE FROM #ExpectException;
END;
';
    EXEC (@Private_ProcessErrorMessage);

    EXEC ('DROP PROCEDURE [AssertEmptyTableTests].[test handles odd names]'); --todo
    EXEC ('DROP PROCEDURE [AssertEmptyTableTests].[test uses tSQLt.TableToText]');
    EXEC ('DROP PROCEDURE [AssertEmptyTableTests].[test works with empty quotable #temptable]'); --todo

    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test all unsupported 2008 data types]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test all unsupported data types]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test can handle byte ordered comparable CLR data type]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test can handle hierarchyid data type]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test multiple rows with multiple mismatching rows]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test RC table is created in the tSQLt schema]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test RC table is marked as tSQLt.IsTempObject]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test_AssertEqualsTable_works_with_actual_having_identity_column]'); --todo
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test_AssertEqualsTable_works_with_equal_temptables]'); --todo
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test_AssertEqualsTable_works_with_expected_having_identity_column]'); --todo

    EXEC ('DROP PROCEDURE [AssertLikeTests].[test AssertLike errors when length of @ExpectedPattern is over 4000 characters]'); --todo

    EXEC ('DROP PROCEDURE [AssertNotEqualsTests].[test AssertNotEquals should give meaningfull failmessage]');

    EXEC ('DROP PROCEDURE [AssertObjectExistsTests].[test_AssertObjectExists_does_not_call_fail_when_table_exists]'); --todo
    EXEC ('DROP PROCEDURE [AssertObjectExistsTests].[test_AssertObjectExists_does_not_call_fail_when_table_is_temp_table]'); --todo

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
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake function with multiple parameters]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake function with one parameter]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake function with table-type parameter]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake function with two part named table as fake data source]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake function with VALUES clause as fake data source]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake Inline table function using a table as fake data source]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake ITVF WITH CLR TVF]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake MSTVF WITH CLR TVF]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake multi-statement table function using a table as fake data source]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake with data source table that starts with select]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test can fake with derived table]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors if function is a CLR SVF and @FakeDataSource is used]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors if function is a SVF and @FakeDataSource is used]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when both @FakeFunctionName and @FakeDataSource are passed]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when function is SVF and fake is ITVF]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when function is SVF and fake is MSTVF]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when function is SVF and fake is not a function]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when parameters of the functions don''t match in max_length]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when parameters of the functions don''t match in name]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when parameters of the functions don''t match in precision]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when parameters of the functions don''t match in scale]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when parameters of the functions don''t match in their order]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test errors when type of return value for scalar functions doesn''t match]'); --todo
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test Fake can be CLR function]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test Fakee can be CLR function]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test FakeFunction calls tSQLt.Private_MarktSQLtTempObject on new object]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test Private_PrepareFakeFunctionOutputTable returns table with SELECT query]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test Private_PrepareFakeFunctionOutputTable returns table with VALUES]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test tSQLt.Private_GetFullTypeName is used for return type]');
    EXEC ('DROP PROCEDURE [FakeFunctionTests].[test tSQLt.Private_GetFullTypeName is used to build parameter list]');
END;
GO