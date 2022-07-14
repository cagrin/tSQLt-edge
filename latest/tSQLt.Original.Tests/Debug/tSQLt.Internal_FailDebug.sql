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

    DECLARE @NL NVARCHAR(MAX) = CHAR(13) + CHAR(10);

    -- [ApplyConstraintTests].[test ApplyConstraint throws error if called with constraint existsing on different table]
    IF  @ErrorMessage = 'tSQLt.ApplyConstraint failed. Constraint:<MyConstraint> on table <schemaA.tableA> does not exist.'
    SET @ErrorMessage = 'ApplyConstraint could not resolve the object names';

    -- [ApplyConstraintTests].[test ApplyConstraint throws error if called with invalid constraint]
    IF  @ErrorMessage = 'tSQLt.ApplyConstraint failed. Constraint:<thisIsNotAConstraint> on table <schemaA.tableA> does not exist.'
    SET @ErrorMessage = 'ApplyConstraint could not resolve the object names, ''schemaA.tableA'', ''thisIsNotAConstraint''. Be sure to call ApplyConstraint and pass in two parameters, such as: EXEC tSQLt.ApplyConstraint ''MySchema.MyTable'', ''MyConstraint''';

    -- [ApplyTriggerTests].[test cannot apply trigger if table does not exist]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<ApplyTriggerTests.NotThere> does not exist.'
    SET @ErrorMessage = 'ApplyTriggerTests.NotThere does not exist or was not faked by tSQLt.FakeTable.';

    -- [ApplyTriggerTests].[test cannot apply trigger if trigger does not exist]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<ApplyTriggerTests.AlsoNotThere> does not exist.'
    SET @ErrorMessage = 'AlsoNotThere is not a trigger on ApplyTriggerTests.TableWithoutTrigger';

    -- [ApplyTriggerTests].[test cannot apply trigger if table is not a faked table]
    IF  @ErrorMessage = 'Table ApplyTriggerTests.NotAFakeTable was not faked by tSQLt.FakeTable.'
    SET @ErrorMessage = 'ApplyTriggerTests.NotAFakeTable does not exist or was not faked by tSQLt.FakeTable.';

    -- [ApplyTriggerTests].[test cannot apply trigger if trigger exist on wrong table]
    IF  @ErrorMessage = 'tSQLt.ApplyTrigger failed. Trigger:<AlsoNotThere> on table <ApplyTriggerTests.TableWithoutTrigger> does not exist.'
    SET @ErrorMessage = 'AlsoNotThere is not a trigger on ApplyTriggerTests.TableWithoutTrigger';
    ELSE
    IF  @ErrorMessage = 'tSQLt.ApplyTrigger failed. Trigger:<MyTrigger> on table <ApplyTriggerTests.TableWithoutTrigger> does not exist.'
    SET @ErrorMessage = 'MyTrigger is not a trigger on ApplyTriggerTests.TableWithoutTrigger';

    -- [AsertEqualsStringTests].[test AssertEqualsString should produce formatted fail message]
    IF  @ErrorMessage = 'tSQLt.AssertEqualsString failed. Expected:<Hello>. Actual:<World!>.'
    SET @ErrorMessage = @NL+'Expected: <Hello>'+@NL+'but was : <World!>';

    -- [AsertEqualsStringTests].[test fail message shows NULL for actual value]
    IF  @ErrorMessage = 'tSQLt.AssertEqualsString failed. Expected:<>. Actual:<(null)>.'
    SET @ErrorMessage = @NL+'Expected: <>'+@NL+'but was : NULL';

    -- [AsertEqualsStringTests].[test fail message shows NULL for expected value]
    IF  @ErrorMessage = 'tSQLt.AssertEqualsString failed. Expected:<(null)>. Actual:<>.'
    SET @ErrorMessage = @NL+'Expected: NULL'+@NL+'but was : <>';

    -- [AssertEmptyTableTests].[test AssertEmptyTable should pass supplied message before original failure message when calling fail]
    IF  @ErrorMessage = '{MyMessage} tSQLt.AssertEmptyTable failed. Expected:<#actual> is not empty.'
    SET @ErrorMessage = '{MyMessage} data1 testdata';

    -- [AssertEmptyTableTests].[test supplied message defaults to '']
    IF  @ErrorMessage = 'tSQLt.AssertEmptyTable failed. Expected:<#actual> is not empty.'
    SET @ErrorMessage = '[#actual]';

    -- [AssertEmptyTableTests].[test fails if #table does not exist]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<#doesnotexist> does not exist.'
    SET @ErrorMessage = '''#doesnotexist'' does not exist';

    -- [AssertEmptyTableTests].[test fails if table does not exist]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<AssertEmptyTableTests.TestTable> does not exist.'
    SET @ErrorMessage = '''AssertEmptyTableTests.TestTable'' does not exist';

    -- [AssertEmptyTableTests].[test uses tSQLt.TableToText]
    IF  @ErrorMessage = 'tSQLt.AssertEmptyTable failed. Expected:<AssertEmptyTableTests.TestTable> is not empty.'
    SET @ErrorMessage = '[AssertEmptyTableTests].[TestTable] was not empty:'+@NL+'{TableToTextResult}';

    -- [AssertEqualsTableSchemaTests].[test fail message is prefixed with supplied message]
    IF  @ErrorMessage = '{supplied message} tSQLt.AssertEqualsTableSchema failed. Expected:<[Id] int NOT NULL, [NoKey] int NULL>. Actual:<[Id] int NOT NULL, [NoKey] bigint NULL>.'
    SET @ErrorMessage = '{supplied message} Unexpected';

    -- [AssertEqualsTableSchemaTests].[test fail message starts with "Unexpected/missing columns\n"]
    IF  @ErrorMessage = 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Id] int NOT NULL, [NoKey] int NULL>. Actual:<[Id] int NOT NULL, [NoKey] bigint NULL>.'
    SET @ErrorMessage = 'Unexpected/missing column(s)'+@NL;

    -- [AssertEqualsTableSchemaTests].[test output contains type names]
    IF  @ErrorMessage = 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Id] bigint NOT NULL, [NoKey] int NULL>. Actual:<[Id] bigint NOT NULL, [NoKey] [AssertEqualsTableSchemaTests].[TestType] NULL>.'
    SET @ErrorMessage = '56[int] 56[int]'+@NL+'127[bigint] 127[bigint]'+@NL+'56[int] [AssertEqualsTableSchemaTests].[TestType]';

    -- [AssertEqualsTableTests].[test ***
    IF  @ErrorMessage = 'tSQLt.AssertEqualsTable failed. Expected:<AssertEqualsTableTests.LeftTable> has different rowset than Actual:<AssertEqualsTableTests.RightTable>.'
    SET @ErrorMessage = 'Unexpected/missing resultset rows!'+@NL;

    -- [AssertEqualsTableTests].[test custom failure message is included in failure result]
    IF  @ErrorMessage = 'Custom failure message tSQLt.AssertEqualsTable failed. Expected:<AssertEqualsTableTests.LeftTable> has different rowset than Actual:<AssertEqualsTableTests.RightTable>.'
    SET @ErrorMessage = 'Custom failure message'+@NL+'Unexpected';

    -- [AssertEqualsTableTests].[test *** table doesn't exist results in failure]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<AssertEqualsTableTests.DoesNotExist> does not exist.'
    SET @ErrorMessage = '''AssertEqualsTableTests.DoesNotExist'' does not exist';

    -- [AssertLikeTests].[test AssertLike allows custom failure message]
    IF  @ErrorMessage = 'Custom Fail Message tSQLt.AssertLike failed. ExpectedPattern:<craft> but Actual:<cruft>.'
    SET @ErrorMessage = 'Custom Fail Message'+@NL+'Expected: <craft>'+@NL+' but was: <cruft>';

    -- [AssertLikeTests].[test AssertLike returns helpful message on failure]
    IF  @ErrorMessage = 'tSQLt.AssertLike failed. ExpectedPattern:<craft> but Actual:<cruft>.'
    SET @ErrorMessage = @NL+'Expected: <craft>'+@NL+' but was: <cruft>';

    -- [AssertNotEqualsTests].[test AssertNotEquals should give meaningfull fail message on NULL]
    IF  @ErrorMessage = 'tSQLt.AssertNotEquals failed. Expected any value except:<(null)>.'
    SET @ErrorMessage = 'Expected actual value to not be NULL.';

    -- [AssertNotEqualsTests].[test AssertNotEquals should give meaningfull failmessage]
    IF  @ErrorMessage = 'tSQLt.AssertNotEquals failed. Expected any value except:<13>.'
    SET @ErrorMessage = 'Expected actual value to not equal <{SVF was called with <13>}>.';

    -- [AssertObjectDoesNotExistTests].[test uses appropriate fail message]
    IF  @ErrorMessage = 'tSQLt.AssertObjectDoesNotExist failed. Object:<#aTempObject> does exist.'
    SET @ErrorMessage = '''#aTempObject'' does exist!';

    -- [AssertStringInTests].[test AssertStringIn passes supplied message before original failure message when calling fail]
    IF  @ErrorMessage = '{MyMessage} tSQLt.AssertStringIn failed. String:<(null)> is not in <(null)>.'
    SET @ErrorMessage = '{MyMessage} NULL value';

    -- [FakeFunctionTests].[test errors when function is ***
    IF @ErrorMessage LIKE 'tSQLt.AssertObjectExists failed. Object:<tSQLt_testutil.AClr%'
    SET @ErrorMessage = 'Both parameters must contain the name of either scalar or table valued functions!';

    -- [FakeFunctionTests].[test errors when function doesn't exist]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<FakeFunctionTests.ANotExistingFunction> does not exist.'
    SET @ErrorMessage = 'FakeFunctionTests.ANotExistingFunction does not exist!';

    -- [FakeFunctionTests].[test errors when fake function doesn't exist]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<FakeFunctionTests.ANotExistingFakeFunction> does not exist.'
    SET @ErrorMessage = 'FakeFunctionTests.ANotExistingFakeFunction does not exist!';

    -- [FakeFunctionTests].[test errors when neither @FakeFunctionName nor @FakeDataSource are passed]
    IF  @ErrorMessage = 'Either @FakeFunctionName or @FakeDataSource must be provided.'
    SET @ErrorMessage = 'Either @FakeFunctionName or @FakeDataSource must be provided';

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

    -- [FakeTableTests].[test raises error if @TableName is multi-part and @SchemaName is not NULL]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<aschema.aschema.anobject> does not exist.'
    SET @ErrorMessage = 'When @TableName is a multi-part identifier, @SchemaName must be NULL!'

    -- [FakeTableTests].[test raises error if @TableName is quoted multi-part and @SchemaName is not NULL]
    IF  @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<aschema.[aschema].[anobject]> does not exist.'
    SET @ErrorMessage = 'When @TableName is a multi-part identifier, @SchemaName must be NULL!'

    -- [RemoveObjectTests].[test RemoveObject raises approporate error if object doesn't exists']
    IF  @ErrorMessage = 'tSQLt.RemoveObject failed. ObjectName:<RemoveObjectTests.aNonExistentTestObject> does not exist.'
    SET @ErrorMessage = 'tSQLt.RemoveObject failed. ObjectName: RemoveObjectTests.aNonExistentTestObject does not exist!';

    RAISERROR(N'%s', 16, 10, @ErrorMessage);
END;
GO