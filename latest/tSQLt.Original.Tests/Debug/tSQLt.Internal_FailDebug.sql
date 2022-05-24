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

    -- [FakeTableTests].[test FakeTable raises appropriate error if table does not exist]
    IF @ErrorMessage LIKE 'tSQLt.AssertObjectExists failed. Object:<schemaA.tableXYZ> does not exist.'
      SET @ErrorMessage = 'FakeTable could not resolve the object name, ''schemaA.tableXYZ''. (When calling tSQLt.FakeTable, avoid the use of the @SchemaName parameter, as it is deprecated.)'

    -- [FakeTableTests].[test FakeTable raises appropriate error if it was called with a single parameter]
    IF @ErrorMessage LIKE 'tSQLt.AssertObjectExists failed. Object:<schemaB.tableXYZ> does not exist.'
      SET @ErrorMessage = 'FakeTable could not resolve the object name, ''schemaB.tableXYZ''. (When calling tSQLt.FakeTable, avoid the use of the @SchemaName parameter, as it is deprecated.)'

    -- [FakeTableTests].[test FakeTable raises appropriate error if called with NULL parameters]
    IF @ErrorMessage LIKE 'tSQLt.AssertObjectExists failed. Object:<(null)> does not exist.'
      SET @ErrorMessage = 'FakeTable could not resolve the object name, ''(null)''.'

    -- [RemoveObjectTests].[test RemoveObject raises approporate error if object doesn't exists']
    IF @ErrorMessage LIKE 'tSQLt.RemoveObject failed. ObjectName:<RemoveObjectTests.aNonExistentTestObject> does not exist.'
      SET @ErrorMessage = 'tSQLt.RemoveObject failed. ObjectName: RemoveObjectTests.aNonExistentTestObject does not exist!';

    RAISERROR(N'%s', 16, 10, @ErrorMessage);
END;
GO