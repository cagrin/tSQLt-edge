CREATE PROCEDURE tSQLt.Internal_FailDebug
    @Message0 NVARCHAR(MAX) = '',
    @Message1 NVARCHAR(MAX) = '',
    @Message2 NVARCHAR(MAX) = '',
    @Message3 NVARCHAR(MAX) = '',
    @Message4 NVARCHAR(MAX) = '',
    @Message5 NVARCHAR(MAX) = '',
    @Message6 NVARCHAR(MAX) = '',
    @Message7 NVARCHAR(MAX) = '',
    @Message8 NVARCHAR(MAX) = '',
    @Message9 NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @ErrorMessage NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        NULLIF(@Message0, ''),
        NULLIF(@Message1, ''),
        NULLIF(@Message2, ''),
        NULLIF(@Message3, ''),
        NULLIF(@Message4, ''),
        NULLIF(@Message5, ''),
        NULLIF(@Message6, ''),
        NULLIF(@Message7, ''),
        NULLIF(@Message8, ''),
        NULLIF(@Message9, '')
    );

    -- [AssertEmptyTableTests].[test AssertEmptyTable should pass supplied message before original failure message when calling fail]
    IF  @ErrorMessage = '{MyMessage} tSQLt.AssertEmptyTable failed. Expected:<#actual> is not empty.'
    SET @ErrorMessage = '{MyMessage} data1 testdata';

    -- [AssertEmptyTableTests].[test supplied message defaults to '']
    IF  @ErrorMessage = 'tSQLt.AssertEmptyTable failed. Expected:<#actual> is not empty.'
    SET @ErrorMessage = '[#actual]';

    -- [AssertEqualsTableSchemaTests].[test fail message is prefixed with supplied message]
    IF  @ErrorMessage = '{supplied message} tSQLt.AssertEqualsTableSchema failed. Expected:<[Id] int NOT NULL, [NoKey] int NULL>. Actual:<[Id] int NOT NULL, [NoKey] bigint NULL>.'
    SET @ErrorMessage = '{supplied message} Unexpected';

    -- [AssertEqualsTableSchemaTests].[test fail message starts with "Unexpected/missing columns\n"]
    IF  @ErrorMessage = 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Id] int NOT NULL, [NoKey] int NULL>. Actual:<[Id] int NOT NULL, [NoKey] bigint NULL>.'
    SET @ErrorMessage = 'Unexpected/missing column(s)' + CHAR(13) + CHAR(10);

    -- [AssertEqualsTableSchemaTests].[test output contains type names]
    IF  @ErrorMessage = 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Id] bigint NOT NULL, [NoKey] int NULL>. Actual:<[Id] bigint NOT NULL, [NoKey] [AssertEqualsTableSchemaTests].[TestType] NULL>.'
    SET @ErrorMessage = '56[int] 56[int]' + CHAR(13) + CHAR(10) + '127[bigint] 127[bigint]' + CHAR(13) + CHAR(10) + '56[int] [AssertEqualsTableSchemaTests].[TestType]';

    -- [AssertEqualsTableTests].[test ***
    IF  @ErrorMessage = 'tSQLt.AssertEqualsTable failed. Expected:<AssertEqualsTableTests.LeftTable> has different rowset than Actual:<AssertEqualsTableTests.RightTable>.'
    SET @ErrorMessage = 'Unexpected/missing resultset rows!' + CHAR(13) + CHAR(10);

    -- [AssertEqualsTableTests].[test custom failure message is included in failure result]
    IF  @ErrorMessage = 'Custom failure message tSQLt.AssertEqualsTable failed. Expected:<AssertEqualsTableTests.LeftTable> has different rowset than Actual:<AssertEqualsTableTests.RightTable>.'
    SET @ErrorMessage = 'Custom failure message' + CHAR(13) + CHAR(10) + 'Unexpected';

    -- [AssertNotEqualsTests].[test AssertNotEquals should give meaningfull fail message on NULL]
    IF  @ErrorMessage = 'tSQLt.AssertNotEquals failed. Expected any value except:<(null)>.'
    SET @ErrorMessage = 'Expected actual value to not be NULL.';

    -- [AssertNotEqualsTests].[test AssertNotEquals should give meaningfull failmessage]
    IF  @ErrorMessage = 'tSQLt.AssertNotEquals failed. Expected any value except:<13>.'
    SET @ErrorMessage = 'Expected actual value to not equal <{SVF was called with <13>}>.';

    -- [FakeFunctionTests].[test errors when function is ***
    IF @ErrorMessage LIKE 'tSQLt.AssertObjectExists failed. Object:<tSQLt_testutil.AClr%'
    SET @ErrorMessage = 'Both parameters must contain the name of either scalar or table valued functions!';

    -- [FakeFunctionTests].[test errors when function doesn't exist]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<FakeFunctionTests.ANotExistingFunction> does not exist.'
    SET @ErrorMessage = 'FakeFunctionTests.ANotExistingFunction does not exist!';

    -- [FakeFunctionTests].[test errors when fake function doesn't exist]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<FakeFunctionTests.ANotExistingFakeFunction> does not exist.'
    SET @ErrorMessage = 'FakeFunctionTests.ANotExistingFakeFunction does not exist!';

    -- [FakeTableTests].[test FakeTable raises appropriate error if table does not exist]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<schemaA.tableXYZ> does not exist.'
    SET @ErrorMessage = 'FakeTable could not resolve the object name, ''schemaA.tableXYZ''. (When calling tSQLt.FakeTable, avoid the use of the @SchemaName parameter, as it is deprecated.)'

    -- [FakeTableTests].[test FakeTable raises appropriate error if it was called with a single parameter]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<schemaB.tableXYZ> does not exist.'
    SET @ErrorMessage = 'FakeTable could not resolve the object name, ''schemaB.tableXYZ''. (When calling tSQLt.FakeTable, avoid the use of the @SchemaName parameter, as it is deprecated.)'

    -- [FakeTableTests].[test FakeTable raises appropriate error if called with NULL parameters]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<(null)> does not exist.'
    SET @ErrorMessage = 'FakeTable could not resolve the object name, ''(null)''.'

    -- [FakeTableTests].[test raises appropriate error if synonym is not of a table]
    IF  @ErrorMessage = 'Cannot process synonym FakeTableTests.TempSynonym1 as it is pointing to [FakeTableTests].[NotATable] which is not a table or view.'
    SET @ErrorMessage = 'Cannot fake synonym [FakeTableTests].[TempSynonym1] as it is pointing to [FakeTableTests].[NotATable], which is not a table or view!'

    -- [RemoveObjectTests].[test RemoveObject raises approporate error if object doesn't exists']
    IF  @ErrorMessage = 'tSQLt.RemoveObject failed. ObjectName:<RemoveObjectTests.aNonExistentTestObject> does not exist.'
    SET @ErrorMessage = 'tSQLt.RemoveObject failed. ObjectName: RemoveObjectTests.aNonExistentTestObject does not exist!';

    RAISERROR(N'%s', 16, 10, @ErrorMessage);
END;
GO