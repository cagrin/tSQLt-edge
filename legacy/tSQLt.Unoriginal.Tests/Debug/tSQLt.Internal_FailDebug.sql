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

    -- [Test_AssertEquals].[Test_5_6]
    IF  @ErrorMessage = 'Expected: <5> but was: <6>'
    SET @ErrorMessage = 'tSQLt.AssertEquals failed. Expected:<5>. Actual:<6>.';

    -- [Test_AssertEquals].[Test_ErrorMessage]
    IF  @ErrorMessage = 'Error message.  Expected: <hello> but was: <hallo>'
    SET @ErrorMessage = 'Error message. tSQLt.AssertEquals failed. Expected:<hello>. Actual:<hallo>.';

    -- [Test_AssertEquals].[Test_FloatLossOfPrecision]
    IF  @ErrorMessage = 'Expected: <0.3> but was: <0.3>'
    SET @ErrorMessage = 'tSQLt.AssertEquals failed. Expected:<0.3>. Actual:<0.3>.';

    -- [Test_AssertEquals].[Test_Hello_Hallo]
    IF  @ErrorMessage = 'Expected: <hello> but was: <hallo>'
    SET @ErrorMessage = 'tSQLt.AssertEquals failed. Expected:<hello>. Actual:<hallo>.';

    -- [Test_AssertEquals].[Test_Hello_NULL]
    IF  @ErrorMessage = 'Expected: <hello> but was: <NULL>'
    SET @ErrorMessage = 'tSQLt.AssertEquals failed. Expected:<hello>. Actual:<(null)>.';

    -- [Test_AssertEquals].[Test_Pi_Pi1]
    IF  @ErrorMessage = 'Expected: <3.14> but was: <3.141>'
    SET @ErrorMessage = 'tSQLt.AssertEquals failed. Expected:<3.14>. Actual:<3.141>.';

    -- [Test_AssertEqualsString].[Test_ErrorMessage]
    IF  @ErrorMessage LIKE 'Error message. __Expected: <hello>__but was : <hallo>'
    SET @ErrorMessage = 'Error message. tSQLt.AssertEqualsString failed. Expected:<hello>. Actual:<hallo>.';

    -- [Test_AssertEqualsString].[Test_Hello_Hallo]
    IF  @ErrorMessage LIKE '__Expected: <hello>__but was : <hallo>'
    SET @ErrorMessage = 'tSQLt.AssertEqualsString failed. Expected:<hello>. Actual:<hallo>.';

    -- [Test_AssertEqualsString].[Test_Hello_NULL]
    IF  @ErrorMessage LIKE '__Expected: <hello>__but was : NULL'
    SET @ErrorMessage = 'tSQLt.AssertEqualsString failed. Expected:<hello>. Actual:<(null)>.';

    -- [Test_AssertLike].[Test_NullH_llo]
    IF  @ErrorMessage LIKE '__Expected: <H[_]llo>__ but was: <NULL>'
    SET @ErrorMessage = 'tSQLt.AssertLike failed. ExpectedPattern:<H_llo> but Actual:<(null)>.';

    -- [Test_AssertLike].[Test_NullH_o]
    IF  @ErrorMessage LIKE '__Expected: <H[%]o>__ but was: <NULL>'
    SET @ErrorMessage = 'tSQLt.AssertLike failed. ExpectedPattern:<H%o> but Actual:<(null)>.';

    -- [Test_AssertLike].[Test_NullPattern]
    IF  @ErrorMessage LIKE '__Expected: <NULL>__ but was: <Hello>'
    SET @ErrorMessage = 'tSQLt.AssertLike failed. ExpectedPattern:<(null)> but Actual:<Hello>.';

    -- [Test_AssertLike].[Test_ErrorMessage]
    IF  @ErrorMessage LIKE 'Error message. __Expected: <NULL>__ but was: <Hello>'
    SET @ErrorMessage = 'Error message. tSQLt.AssertLike failed. ExpectedPattern:<(null)> but Actual:<Hello>.';

    --- [Test_AssertNotEquals].[Test_NULL_NULL]
    IF  @ErrorMessage = 'Expected actual value to not be NULL.'
    SET @ErrorMessage = 'tSQLt.AssertNotEquals failed. Expected any value except:<(null)>.';

    -- [Test_AssertNotEquals].[Test_Pi_Pi]
    IF  @ErrorMessage = 'Expected actual value to not equal <3.14>.'
    SET @ErrorMessage = 'tSQLt.AssertNotEquals failed. Expected any value except:<3.14>.';

    -- [Test_AssertNotEquals].[Test_Hello_Hello]
    IF  @ErrorMessage = 'Expected actual value to not equal <hello>.'
    SET @ErrorMessage = 'tSQLt.AssertNotEquals failed. Expected any value except:<hello>.';

    -- [Test_AssertNotEquals].[Test_5_5]
    IF  @ErrorMessage = 'Expected actual value to not equal <5>.'
    SET @ErrorMessage = 'tSQLt.AssertNotEquals failed. Expected any value except:<5>.';

    -- [Test_AssertNotEquals].[Test_ErrorMessage]
    IF  @ErrorMessage = 'Error message. Expected actual value to not equal <hello>.'
    SET @ErrorMessage = 'Error message. tSQLt.AssertNotEquals failed. Expected any value except:<hello>.';

    -- [Test_AssertObjectDoesNotExist].[Test_DoesExist]
    IF  @ErrorMessage = '''dbo.TestTable1'' does exist!'
    SET @ErrorMessage = 'tSQLt.AssertObjectDoesNotExist failed. Object:<dbo.TestTable1> does exist.';

    -- [Test_AssertObjectDoesNotExist].[Test_ExternalDoesExist]
    IF  @ErrorMessage = '''master.dbo.TestTable1'' does exist!'
    SET @ErrorMessage = 'tSQLt.AssertObjectDoesNotExist failed. Object:<master.dbo.TestTable1> does exist.';

    -- [Test_AssertObjectDoesNotExist].[Test_TempDoesExist]
    IF  @ErrorMessage = '''#TestTable1'' does exist!'
    SET @ErrorMessage = 'tSQLt.AssertObjectDoesNotExist failed. Object:<#TestTable1> does exist.';

    -- [Test_AssertObjectDoesNotExist].[Test_ErrorMessage]
    IF  @ErrorMessage = 'Error message. ''dbo.TestTable1'' does exist!'
    SET @ErrorMessage = 'Error message. tSQLt.AssertObjectDoesNotExist failed. Object:<dbo.TestTable1> does exist.';

    -- [AssertObjectExists].[Test_ExternalDoesNotExist]
    IF  @ErrorMessage = '''master.dbo.TestTable1'' does not exist'
    SET @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<master.dbo.TestTable1> does not exist.';

    -- [AssertObjectExists].[Test_ErrorMessage]
    IF  @ErrorMessage = 'Error message. ''dbo.TestTable1'' does not exist'
    SET @ErrorMessage = 'Error message. tSQLt.AssertObjectExists failed. Object:<dbo.TestTable1> does not exist.';

    -- [AssertObjectExists].[Test_DoesNotExist]
    IF  @ErrorMessage = '''dbo.TestTable1'' does not exist'
    SET @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<dbo.TestTable1> does not exist.';

    -- [AssertObjectExists].[Test_TempDoesNotExist]
    IF  @ErrorMessage = '''#TestTable1'' does not exist'
    SET @ErrorMessage = 'tSQLt.AssertObjectExists failed. Object:<#TestTable1> does not exist.';

    -- [AssertStringIn].[Test_Empty_Hello]
    IF  @ErrorMessage LIKE '<Hello>__is not in__|value|__+-----+'
    SET @ErrorMessage = 'tSQLt.AssertStringIn failed. String:<Hello> is not in <(null)>.';

    -- [AssertStringIn].[Test_Empty_Null]
    IF  @ErrorMessage LIKE 'NULL__is not in__|value|__+-----+'
    SET @ErrorMessage = 'tSQLt.AssertStringIn failed. String:<(null)> is not in <(null)>.';

    -- [AssertStringIn].[Test_Hello_Hallo]
    IF  @ErrorMessage LIKE '<Hallo>__is not in__|value|__+-----+__|Hello|__|World|'
    SET @ErrorMessage = 'tSQLt.AssertStringIn failed. String:<Hallo> is not in <Hello, World>.';

    RAISERROR(N'%s', 16, 10, @ErrorMessage);
END;
GO