EXEC tSQLt.NewTestClass 'AsertEqualsStringTests';
GO

CREATE PROC AsertEqualsStringTests.[test AssertEqualsString should do nothing with two equal VARCHAR Max Values]
AS
BEGIN
    DECLARE @TestString VARCHAR(Max);
    SET @TestString = REPLICATE(CAST('TestString' AS VARCHAR(MAX)),1000);
    EXEC tSQLt.AssertEqualsString @TestString, @TestString;
END
GO

CREATE PROC AsertEqualsStringTests.[test AssertEqualsString should do nothing with two NULLs]
AS
BEGIN
    EXEC tSQLt.AssertEqualsString NULL, NULL;
END
GO

CREATE PROC AsertEqualsStringTests.[test AssertEqualsString should call fail with nonequal VARCHAR MAX]
AS
BEGIN
    DECLARE @TestString1 VARCHAR(MAX);
    SET @TestString1 = REPLICATE(CAST('TestString' AS VARCHAR(MAX)),1000)+'1';
    DECLARE @TestString2 VARCHAR(MAX);
    SET @TestString2 = REPLICATE(CAST('TestString' AS VARCHAR(MAX)),1000)+'2';

    DECLARE @Command VARCHAR(MAX); SET @Command = 'EXEC tSQLt.AssertEqualsString ''' + @TestString1 + ''', ''' + @TestString2 + ''';';
    EXEC tSQLt_testutil.assertFailCalled @Command, 'AssertEqualsString did not call Fail';
END;
GO

CREATE PROC AsertEqualsStringTests.[test AssertEqualsString should call fail with expected value and actual NULL]
AS
BEGIN
    DECLARE @Command VARCHAR(MAX); SET @Command = 'EXEC tSQLt.AssertEqualsString ''1'', NULL;';
    EXEC tSQLt_testutil.assertFailCalled @Command, 'AssertEqualsString did not call Fail';
END;
GO

CREATE PROC AsertEqualsStringTests.[test AssertEqualsString should call fail with expected NULL and actual value]
AS
BEGIN
    DECLARE @Command VARCHAR(MAX); SET @Command = 'EXEC tSQLt.AssertEqualsString NULL, ''1'';';
    EXEC tSQLt_testutil.assertFailCalled @Command, 'AssertEqualsString did not call Fail';
END;
GO

CREATE PROC AsertEqualsStringTests.[test AssertEqualsString with expected NVARCHAR(MAX) and actual VARCHAR(MAX) of same value]
AS
BEGIN
    DECLARE @Expected NVARCHAR(MAX); SET @Expected = N'hello';
    DECLARE @Actual VARCHAR(MAX); SET @Actual = 'hello';
    EXEC tSQLt.AssertEqualsString @Expected, @Actual;
END;
GO

CREATE PROC AsertEqualsStringTests.[test AssertEqualsString should produce formatted fail message]
AS
BEGIN
  DECLARE @ExpectedMessage NVARCHAR(MAX);
  SET @ExpectedMessage = CHAR(13)+CHAR(10)+
                         'Expected: <Hello>'+CHAR(13)+CHAR(10)+
                         'but was : <World!>'

  EXEC tSQLt_testutil.AssertFailMessageEquals
       'EXEC tSQLt.AssertEqualsString N''Hello'', N''World!'';',
       @ExpectedMessage;
END;
GO

CREATE PROC AsertEqualsStringTests.[test fail message shows NULL for expected value]
AS
BEGIN
  DECLARE @ExpectedMessage NVARCHAR(MAX);
  SET @ExpectedMessage = CHAR(13)+CHAR(10)+
                         'Expected: NULL'+CHAR(13)+CHAR(10)+
                         'but was : <>';

  EXEC tSQLt_testutil.AssertFailMessageEquals
       'EXEC tSQLt.AssertEqualsString NULL,'''';',
       @ExpectedMessage;
END;
GO

CREATE PROC AsertEqualsStringTests.[test fail message shows NULL for actual value]
AS
BEGIN
  DECLARE @ExpectedMessage NVARCHAR(MAX);
  SET @ExpectedMessage = CHAR(13)+CHAR(10)+
                         'Expected: <>'+CHAR(13)+CHAR(10)+
                         'but was : NULL';

  EXEC tSQLt_testutil.AssertFailMessageEquals
       'EXEC tSQLt.AssertEqualsString '''',NULL;',
       @ExpectedMessage;
END;
GO