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