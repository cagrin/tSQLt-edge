CREATE PROCEDURE tSQLt.Debug
AS
BEGIN
    EXEC ('DROP PROCEDURE [AssertEmptyTableTests].[test handles odd names]'); --todo
    EXEC ('DROP PROCEDURE [AssertEmptyTableTests].[test uses tSQLt.TableToText]');
    EXEC ('DROP PROCEDURE [AssertEmptyTableTests].[test works with empty quotable #temptable]'); --todo

    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test all unsupported 2008 data types]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test all unsupported data types]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test can handle byte ordered comparable CLR data type]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test can handle hierarchyid data type]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test considers NULL values identical]'); --todo
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test multiple rows with multiple mismatching rows]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test RC table is created in the tSQLt schema]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test RC table is marked as tSQLt.IsTempObject]');
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test_AssertEqualsTable_works_with_actual_having_identity_column]'); --todo
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test_AssertEqualsTable_works_with_equal_temptables]'); --todo
    EXEC ('DROP PROCEDURE [AssertEqualsTableTests].[test_AssertEqualsTable_works_with_expected_having_identity_column]'); --todo
END;
GO