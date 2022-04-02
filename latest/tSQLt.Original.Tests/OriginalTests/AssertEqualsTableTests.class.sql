GO
EXEC tSQLt.NewTestClass 'AssertEqualsTableTests';
GO

CREATE PROCEDURE AssertEqualsTableTests.[test left table doesn't exist results in failure]
AS
BEGIN
  CREATE TABLE AssertEqualsTableTests.RightTable (i INT);

  EXEC tSQLt_testutil.AssertFailMessageEquals
   'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.DoesNotExist'', ''AssertEqualsTableTests.RightTable''',
   '''AssertEqualsTableTests.DoesNotExist'' does not exist',
   'Expected AssertEqualsTable to fail.';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test right table doesn't exist results in failure]
AS
BEGIN
  CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);

  EXEC tSQLt_testutil.AssertFailMessageEquals
   'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.DoesNotExist''',
   '''AssertEqualsTableTests.DoesNotExist'' does not exist',
   'Expected AssertEqualsTable to fail.';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test two tables with no rows and same schema are equal]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);

   EXEC tSQLt.AssertEqualsTable 'AssertEqualsTableTests.LeftTable', 'AssertEqualsTableTests.RightTable';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.CopyResultTable
@InResultTableName NVARCHAR(MAX)
AS
BEGIN
  DECLARE @cmd NVARCHAR(MAX);
  SET @cmd = 'INSERT INTO AssertEqualsTableTests.ResultTable SELECT * FROM '+@InResultTableName;
  EXEC(@cmd);
END
GO

CREATE PROCEDURE AssertEqualsTableTests.[test left 1 row, right table 0 rows are not equal]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1);
   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1),i INT);
   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_],i)
   SELECT '<',1;
   DECLARE @ExpectedMessage NVARCHAR(MAX);
   EXEC tSQLt.TableToText @TableName = 'AssertEqualsTableTests.ResultTable', @OrderBy = '_m_',@txt = @ExpectedMessage OUTPUT;
   SET @ExpectedMessage = 'Unexpected/missing resultset rows!'+CHAR(13)+CHAR(10)+@ExpectedMessage;

   EXEC tSQLt_testutil.AssertFailMessageEquals
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'';',
     @ExpectedMessage,
     'Fail was not called with expected message:';

END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test right table 1 row, left table 0 rows are not equal]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1),i INT);
   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_],i)
   SELECT '>',1;
   DECLARE @ExpectedMessage NVARCHAR(MAX);
   EXEC tSQLt.TableToText @TableName = 'AssertEqualsTableTests.ResultTable', @OrderBy = '_m_',@txt = @ExpectedMessage OUTPUT;
   SET @ExpectedMessage = 'Unexpected/missing resultset rows!'+CHAR(13)+CHAR(10)+@ExpectedMessage;

   EXEC tSQLt_testutil.AssertFailMessageEquals
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'';',
     @ExpectedMessage,
     'Fail was not called with expected message:';

END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test one row in each table, but row is different]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (13);

   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (42);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1),i INT);
   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_],i)
   SELECT '<',13;

   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_],i)
   SELECT '>',42;
   DECLARE @ExpectedMessage NVARCHAR(MAX);
   EXEC tSQLt.TableToText @TableName = 'AssertEqualsTableTests.ResultTable', @OrderBy = '_m_',@txt = @ExpectedMessage OUTPUT;
   SET @ExpectedMessage = 'Unexpected/missing resultset rows!'+CHAR(13)+CHAR(10)+@ExpectedMessage;

   EXEC tSQLt_testutil.AssertFailMessageEquals
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'';',
     @ExpectedMessage,
     'Fail was not called with expected message:';

END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test same single row in each table]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1);

   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1);

   EXEC tSQLt.AssertEqualsTable 'AssertEqualsTableTests.LeftTable', 'AssertEqualsTableTests.RightTable';

END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test same multiple rows in each table]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (2);

   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (2);

   EXEC tSQLt.AssertEqualsTable 'AssertEqualsTableTests.LeftTable', 'AssertEqualsTableTests.RightTable';

END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test multiple rows with one mismatching row]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (3);

   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (2);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1),i INT);
   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_],i)
   SELECT '=',1 UNION ALL
   SELECT '<',3 UNION ALL
   SELECT '>',2;

   DECLARE @ExpectedMessage NVARCHAR(MAX);
   EXEC tSQLt.TableToText @TableName = 'AssertEqualsTableTests.ResultTable', @OrderBy = '_m_',@txt = @ExpectedMessage OUTPUT;
   SET @ExpectedMessage = 'Unexpected/missing resultset rows!'+CHAR(13)+CHAR(10)+@ExpectedMessage;

   EXEC tSQLt_testutil.AssertFailMessageEquals
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'';',
     @ExpectedMessage,
     'Fail was not called with expected message:';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test compare table with two columns and no rows]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (a INT, b INT);

   CREATE TABLE AssertEqualsTableTests.RightTable (a INT, b INT);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1), a INT, b INT);
   EXEC tSQLt.AssertEqualsTable 'AssertEqualsTableTests.LeftTable', 'AssertEqualsTableTests.RightTable';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test same single row in each table with two columns]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (a INT, b INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1, 2);

   CREATE TABLE AssertEqualsTableTests.RightTable (a INT, b INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1, 2);

   EXEC tSQLt.AssertEqualsTable 'AssertEqualsTableTests.LeftTable', 'AssertEqualsTableTests.RightTable';

END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test same multiple rows in each table with two columns]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (a INT, b INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1, 2);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (3, 4);

   CREATE TABLE AssertEqualsTableTests.RightTable (a INT, b INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1, 2);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (3, 4);

   EXEC tSQLt.AssertEqualsTable 'AssertEqualsTableTests.LeftTable', 'AssertEqualsTableTests.RightTable';

END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test multiple rows with one mismatching row with two columns]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (a INT, b INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (11, 12);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (31, 32);

   CREATE TABLE AssertEqualsTableTests.RightTable (a INT, b INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (11, 12);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (21, 22);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1), a INT, b INT);
   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_], a, b)
   SELECT '=', 11, 12 UNION ALL
   SELECT '<', 31, 32 UNION ALL
   SELECT '>', 21, 22;

   DECLARE @ExpectedMessage NVARCHAR(MAX);
   EXEC tSQLt.TableToText @TableName = 'AssertEqualsTableTests.ResultTable', @OrderBy = '_m_',@txt = @ExpectedMessage OUTPUT;
   SET @ExpectedMessage = 'Unexpected/missing resultset rows!'+CHAR(13)+CHAR(10)+@ExpectedMessage;

   EXEC tSQLt_testutil.AssertFailMessageEquals
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'';',
     @ExpectedMessage,
     'Fail was not called with expected message:';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test multiple rows with one mismatching row with mismatching column values in last column]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (a INT, b INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (11, 199);

   CREATE TABLE AssertEqualsTableTests.RightTable (a INT, b INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (11, 12);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1), a INT, b INT);
   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_], a, b)
   SELECT '<', 11, 199 UNION ALL
   SELECT '>', 11, 12;

   DECLARE @ExpectedMessage NVARCHAR(MAX);
   EXEC tSQLt.TableToText @TableName = 'AssertEqualsTableTests.ResultTable', @OrderBy = '_m_',@txt = @ExpectedMessage OUTPUT;
   SET @ExpectedMessage = 'Unexpected/missing resultset rows!'+CHAR(13)+CHAR(10)+@ExpectedMessage;

   EXEC tSQLt_testutil.AssertFailMessageEquals
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'';',
     @ExpectedMessage,
     'Fail was not called with expected message:';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test multiple rows with one mismatching row with mismatching column values in first column]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (a INT, b INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (199, 12);

   CREATE TABLE AssertEqualsTableTests.RightTable (a INT, b INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (11, 12);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1), a INT, b INT);
   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_], a, b)
   SELECT '<', 199, 12 UNION ALL
   SELECT '>', 11, 12;

   DECLARE @ExpectedMessage NVARCHAR(MAX);
   EXEC tSQLt.TableToText @TableName = 'AssertEqualsTableTests.ResultTable', @OrderBy = '_m_',@txt = @ExpectedMessage OUTPUT;
   SET @ExpectedMessage = 'Unexpected/missing resultset rows!'+CHAR(13)+CHAR(10)+@ExpectedMessage;

   EXEC tSQLt_testutil.AssertFailMessageEquals
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'';',
     @ExpectedMessage,
     'Fail was not called with expected message:';
END;
GO

--- At this point, AssertEqualsTable is tested enough we feel confident in using it in the remaining tests ---

CREATE PROCEDURE AssertEqualsTableTests.[test multiple rows with multiple mismatching rows]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (3);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (5);

   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (2);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (4);

   CREATE TABLE AssertEqualsTableTests.ExpectedResultTable ([_m_] CHAR(1),i INT);
   INSERT INTO AssertEqualsTableTests.ExpectedResultTable ([_m_],i)
   SELECT '=',1 UNION ALL
   SELECT '>',2 UNION ALL
   SELECT '<',3 UNION ALL
   SELECT '>',4 UNION ALL
   SELECT '<',5;

   CREATE TABLE AssertEqualsTableTests.ActualResultTable ([_m_] CHAR(1),i INT);
   EXEC tSQLt.Private_CompareTables 'AssertEqualsTableTests.LeftTable', 'AssertEqualsTableTests.RightTable', 'AssertEqualsTableTests.ActualResultTable', 'i', '_m_';

   EXEC tSQLt.AssertEqualsTable 'AssertEqualsTableTests.ExpectedResultTable', 'AssertEqualsTableTests.ActualResultTable';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test same row in each table but different row counts]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (3);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (3);

   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (3);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1),i INT);
   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_],i)
   SELECT '=',1 UNION ALL
   SELECT '=',3 UNION ALL
   SELECT '<',3;

   DECLARE @ExpectedMessage NVARCHAR(MAX);
   EXEC tSQLt.TableToText @TableName = 'AssertEqualsTableTests.ResultTable', @OrderBy = '_m_',@txt = @ExpectedMessage OUTPUT;
   SET @ExpectedMessage = 'Unexpected/missing resultset rows!'+CHAR(13)+CHAR(10)+@ExpectedMessage;

   EXEC tSQLt_testutil.AssertFailMessageEquals
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'';',
     @ExpectedMessage,
     'Fail was not called with expected message:';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test same row in each table but different row counts with more rows]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (3);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (3);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (3);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (3);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (3);

   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (1);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (3);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (3);
   INSERT INTO AssertEqualsTableTests.RightTable VALUES (3);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1),i INT);
   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_],i)
   SELECT '=',1 UNION ALL
   SELECT '=',1 UNION ALL
   SELECT '>',1 UNION ALL
   SELECT '>',1 UNION ALL
   SELECT '=',3 UNION ALL
   SELECT '=',3 UNION ALL
   SELECT '=',3 UNION ALL
   SELECT '<',3 UNION ALL
   SELECT '<',3;

   DECLARE @ExpectedMessage NVARCHAR(MAX);
   EXEC tSQLt.TableToText @TableName = 'AssertEqualsTableTests.ResultTable', @OrderBy = '_m_',@txt = @ExpectedMessage OUTPUT;
   SET @ExpectedMessage = 'Unexpected/missing resultset rows!'+CHAR(13)+CHAR(10)+@ExpectedMessage;

   EXEC tSQLt_testutil.AssertFailMessageEquals
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'';',
     @ExpectedMessage,
     'Fail was not called with expected message:';
END;
GO


CREATE PROCEDURE AssertEqualsTableTests.[Create tables to compare]
 @DataType NVARCHAR(MAX),
 @Values NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Cmd NVARCHAR(MAX);

  SET @Cmd = '
   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1), a <<DATATYPE>>);
   CREATE TABLE AssertEqualsTableTests.LeftTable (a <<DATATYPE>>);
   CREATE TABLE AssertEqualsTableTests.RightTable (a <<DATATYPE>>);

   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_], a)
   SELECT e,v FROM(
    SELECT <<VALUES>>
   )X([=],[<],[>])
   UNPIVOT (v FOR e IN ([=],[<],[>])) AS u;
   ';

   SET @Cmd = REPLACE(@Cmd, '<<DATATYPE>>', @DataType);
   SET @Cmd = REPLACE(@Cmd, '<<VALUES>>', @Values);

   EXEC(@Cmd);


   INSERT INTO AssertEqualsTableTests.LeftTable (a)
   SELECT a FROM AssertEqualsTableTests.ResultTable WHERE [_m_] <> '>';

   INSERT INTO AssertEqualsTableTests.RightTable (a)
   SELECT a FROM AssertEqualsTableTests.ResultTable WHERE [_m_] <> '<';
END;
GO


CREATE PROCEDURE AssertEqualsTableTests.[Drop tables to compare]
AS
BEGIN
   DROP TABLE AssertEqualsTableTests.ResultTable;
   DROP TABLE AssertEqualsTableTests.LeftTable;
   DROP TABLE AssertEqualsTableTests.RightTable;
END;
GO


CREATE PROCEDURE AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype]
 @DataType NVARCHAR(MAX),
 @Values NVARCHAR(MAX)
AS
BEGIN
   EXEC AssertEqualsTableTests.[Create tables to compare] @DataType, @Values;

   DECLARE @ExpectedMessage NVARCHAR(MAX);
   EXEC tSQLt.TableToText @TableName = 'AssertEqualsTableTests.ResultTable', @OrderBy = '_m_',@txt = @ExpectedMessage OUTPUT;
   SET @ExpectedMessage = 'Unexpected/missing resultset rows!'+CHAR(13)+CHAR(10)+@ExpectedMessage;

   EXEC tSQLt_testutil.AssertFailMessageEquals
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'';',
     @ExpectedMessage,
     'Fail was not called with expected message for datatype ',
     @DataType,
     ':';

   EXEC AssertEqualsTableTests.[Drop tables to compare];
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test considers NULL values identical]
AS
BEGIN
  SELECT NULL [aNULLColumn] INTO #Actual;
  SELECT NULL [aNULLColumn] INTO #Expected;

  EXEC tSQLt.AssertEqualsTable #Expected, #Actual;
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test can handle integer data types]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'BIT', '1,1,0';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'TINYINT', '10,11,12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'SMALLINT', '10,11,12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'INT', '10,11,12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'BIGINT', '10,11,12';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test can handle binary data types]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'BINARY(1)', '0x10,0x11,0x12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'VARBINARY(2)', '0x10,0x11,0x12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'VARBINARY(MAX)', '0x10,0x11,0x12';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test can handle char data types]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'CHAR(2)', '''10'',''11'',''12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'NCHAR(2)', '''10'',''11'',''12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'VARCHAR(2)', '''10'',''11'',''12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'NVARCHAR(2)', '''10'',''11'',''12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'VARCHAR(MAX)', '''10'',''11'',''12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'NVARCHAR(MAX)', '''10'',''11'',''12''';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test can handle decimal data types]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'DECIMAL(10,2)', '0.10, 0.11, 0.12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'NUMERIC(10,2)', '0.10, 0.11, 0.12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'SMALLMONEY', '0.10, 0.11, 0.12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'MONEY', '0.10, 0.11, 0.12';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test can handle floating point data types]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'FLOAT', '1E-10, 1E-11, 1E-12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'REAL', '1E-10, 1E-11, 1E-12';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test can handle date data types]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'SMALLDATETIME', '''2012-01-01 12:00'',''2012-06-19 12:00'',''2012-10-25 12:00''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'DATETIME', '''2012-01-01 12:00'',''2012-06-19 12:00'',''2012-10-25 12:00''';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test can handle uniqueidentifier data type]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'UNIQUEIDENTIFIER', '''10101010-1010-1010-1010-101010101010'',''11111111-1111-1111-1111-111111111111'',''12121212-1212-1212-1212-121212121212''';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test can handle sql_variant data type]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'SQL_VARIANT', '10,11,12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'SQL_VARIANT', '''A'',''B'',''C''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'SQL_VARIANT', 'CAST(''2010-10-10'' AS DATETIME),CAST(''2011-11-11'' AS DATETIME),CAST(''2012-12-12'' AS DATETIME)';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test can handle byte ordered comparable CLR data type]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'tSQLt_testutil.DataTypeByteOrdered', '''10'',''11'',''12''';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[Assert that AssertEqualsTable can NOT handle a datatype]
 @DataType NVARCHAR(MAX),
 @Values NVARCHAR(MAX)
AS
BEGIN
   EXEC AssertEqualsTableTests.[Create tables to compare] @DataType, @Values;

   DECLARE @Message NVARCHAR(MAX);
   SET @Message = 'No Error';

   BEGIN TRY
     EXEC tSQLt.AssertEqualsTable 'AssertEqualsTableTests.LeftTable', 'AssertEqualsTableTests.RightTable';
   END TRY
   BEGIN CATCH
     SELECT @Message = ERROR_MESSAGE();
   END CATCH

   EXEC tSQLt.AssertLike '%The table contains a datatype that is not supported for tSQLt.AssertEqualsTable%Please refer to http://tsqlt.org/user-guide/assertions/assertequalstable/ for a list of unsupported datatypes%',@Message;

   EXEC AssertEqualsTableTests.[Drop tables to compare];
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test all unsupported data types]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can NOT handle a datatype] 'tSQLt_testutil.DataTypeNoEqual', '''10'',''11'',''12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can NOT handle a datatype] 'tSQLt_testutil.DataTypeWithEqual', '''10'',''11'',''12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can NOT handle a datatype] 'TEXT', '''10'',''11'',''12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can NOT handle a datatype] 'NTEXT', '''10'',''11'',''12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can NOT handle a datatype] 'IMAGE', '0x10,0x11,0x12';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can NOT handle a datatype] 'XML', '''<X1 />'',''<X2 />'',''<X3 />''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can NOT handle a datatype] 'INT, c ROWVERSION', '0,0,0';--ROWVERSION is automatically valued
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test column name can be reserved word]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable ([key] INT);
   CREATE TABLE AssertEqualsTableTests.RightTable ([key] INT);

   EXEC tSQLt.AssertEqualsTable 'AssertEqualsTableTests.LeftTable', 'AssertEqualsTableTests.RightTable';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test column name can contain garbage]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable ([column with key G@r8'a9/;GO create table] INT);
   CREATE TABLE AssertEqualsTableTests.RightTable ([column with key G@r8'a9/;GO create table] INT);

   EXEC tSQLt.AssertEqualsTable 'AssertEqualsTableTests.LeftTable', 'AssertEqualsTableTests.RightTable';
END;
GO

CREATE PROCEDURE AssertEqualsTableTests.[test custom failure message is included in failure result]
AS
BEGIN
   CREATE TABLE AssertEqualsTableTests.LeftTable (i INT);
   INSERT INTO AssertEqualsTableTests.LeftTable VALUES (1);
   CREATE TABLE AssertEqualsTableTests.RightTable (i INT);

   CREATE TABLE AssertEqualsTableTests.ResultTable ([_m_] CHAR(1),i INT);
   INSERT INTO AssertEqualsTableTests.ResultTable ([_m_],i)
   SELECT '<',1;
   DECLARE @ExpectedMessage NVARCHAR(MAX);
   SET @ExpectedMessage = 'Custom failure message'+CHAR(13)+CHAR(10)+'Unexpected%';

   EXEC tSQLt_testutil.AssertFailMessageLike
     'EXEC tSQLt.AssertEqualsTable ''AssertEqualsTableTests.LeftTable'', ''AssertEqualsTableTests.RightTable'', @Message = ''Custom failure message'';',
     @ExpectedMessage,
     'Fail was not called with expected message:';

END;
GO

CREATE PROC AssertEqualsTableTests.test_assertEqualsTable_raises_appropriate_error_if_expected_table_does_not_exist
AS
BEGIN
    DECLARE @ErrorThrown BIT; SET @ErrorThrown = 0;

    EXEC ('CREATE SCHEMA schemaA');
    CREATE TABLE schemaA.actual (constCol CHAR(3) );

    DECLARE @Command NVARCHAR(MAX);
    SET @Command = 'EXEC tSQLt.AssertEqualsTable ''schemaA.expected'', ''schemaA.actual'';';
    EXEC tSQLt_testutil.assertFailCalled @Command, 'assertEqualsTable did not call Fail when expected table does not exist';
END;
GO

CREATE PROC AssertEqualsTableTests.test_assertEqualsTable_raises_appropriate_error_if_actual_table_does_not_exist
AS
BEGIN
    DECLARE @ErrorThrown BIT; SET @ErrorThrown = 0;

    EXEC ('CREATE SCHEMA schemaA');
    CREATE TABLE schemaA.expected (constCol CHAR(3) );

    DECLARE @Command NVARCHAR(MAX);
    SET @Command = 'EXEC tSQLt.AssertEqualsTable ''schemaA.expected'', ''schemaA.actual'';';
    EXEC tSQLt_testutil.assertFailCalled @Command, 'assertEqualsTable did not call Fail when actual table does not exist';
END;
GO

CREATE PROC AssertEqualsTableTests.test_AssertEqualsTable_works_with_temptables
AS
BEGIN
    DECLARE @ErrorThrown BIT; SET @ErrorThrown = 0;

    CREATE TABLE #T1(I INT)
    INSERT INTO #T1 SELECT 1
    CREATE TABLE #T2(I INT)
    INSERT INTO #T2 SELECT 2

    DECLARE @Command NVARCHAR(MAX);
    SET @Command = 'EXEC tSQLt.AssertEqualsTable ''#T1'', ''#T2'';';
    EXEC tSQLt_testutil.assertFailCalled @Command, 'assertEqualsTable did not call Fail when comparing temp tables';
END;
GO

CREATE PROC AssertEqualsTableTests.test_AssertEqualsTable_works_with_equal_temptables
AS
BEGIN
    DECLARE @ErrorRaised INT; SET @ErrorRaised = 0;

    EXEC('CREATE SCHEMA MyTestClass;');
    CREATE TABLE #T1(I INT)
    INSERT INTO #T1 SELECT 42
    CREATE TABLE #T2(I INT)
    INSERT INTO #T2 SELECT 42
    EXEC('CREATE PROC MyTestClass.TestCaseA AS EXEC tSQLt.AssertEqualsTable ''#T1'', ''#T2'';');

    BEGIN TRY
        EXEC tSQLt.Run 'MyTestClass.TestCaseA';
    END TRY
    BEGIN CATCH
        SET @ErrorRaised = 1;
    END CATCH
    SELECT Class, TestCase, Result
      INTO actual
      FROM tSQLt.TestResult;
    SELECT 'MyTestClass' Class, 'TestCaseA' TestCase, 'Success' Result
      INTO expected;

    EXEC tSQLt.AssertEqualsTable 'expected', 'actual';
END;
GO
CREATE PROC AssertEqualsTableTests.test_AssertEqualsTable_works_with_expected_having_identity_column
AS
BEGIN
    DECLARE @ErrorRaised INT; SET @ErrorRaised = 0;

    EXEC('CREATE SCHEMA MyTestClass;');
    CREATE TABLE #T1(I INT IDENTITY(1,1));
    INSERT INTO #T1 DEFAULT VALUES;
    CREATE TABLE #T2(I INT);
    INSERT INTO #T2 VALUES(1);
    EXEC('CREATE PROC MyTestClass.TestCaseA AS EXEC tSQLt.AssertEqualsTable ''#T1'', ''#T2'';');

    BEGIN TRY
        EXEC tSQLt.Run 'MyTestClass.TestCaseA';
    END TRY
    BEGIN CATCH
        SET @ErrorRaised = 1;
    END CATCH
    SELECT Class, TestCase, Result
      INTO actual
      FROM tSQLt.TestResult;
    SELECT 'MyTestClass' Class, 'TestCaseA' TestCase, 'Success' Result
      INTO expected;

    EXEC tSQLt.AssertEqualsTable 'expected', 'actual';
END;
GO

CREATE PROC AssertEqualsTableTests.test_AssertEqualsTable_works_with_actual_having_identity_column
AS
BEGIN
    DECLARE @ErrorRaised INT; SET @ErrorRaised = 0;

    EXEC('CREATE SCHEMA MyTestClass;');
    CREATE TABLE #T1(I INT);
    INSERT INTO #T1 VALUES(1);
    CREATE TABLE #T2(I INT IDENTITY(1,1));
    INSERT INTO #T2 DEFAULT VALUES;
    EXEC('CREATE PROC MyTestClass.TestCaseA AS EXEC tSQLt.AssertEqualsTable ''#T1'', ''#T2'';');

    BEGIN TRY
        EXEC tSQLt.Run 'MyTestClass.TestCaseA';
    END TRY
    BEGIN CATCH
        SET @ErrorRaised = 1;
    END CATCH
    SELECT Class, TestCase, Result
      INTO actual
      FROM tSQLt.TestResult;
    SELECT 'MyTestClass' Class, 'TestCaseA' TestCase, 'Success' Result
      INTO expected;

    EXEC tSQLt.AssertEqualsTable 'expected', 'actual';
END;
GO
--[@tSQLt:MinSqlMajorVersion](10)
CREATE PROCEDURE AssertEqualsTableTests.[test can handle 2008 date data types]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'DATE', '''2012-01-01'',''2012-06-19'',''2012-10-25''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'TIME', '''10:10:10'',''11:11:11'',''12:12:12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'DATETIMEOFFSET', '''2012-01-01 10:10:10.101010 +10:10'',''2012-06-19 11:11:11.111111 +11:11'',''2012-10-25 12:12:12.121212 -12:12''';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'DATETIME2', '''2012-01-01 10:10:10.101010'',''2012-06-19 11:11:11.111111'',''2012-10-25 12:12:12.121212''';
END;
GO
--[@tSQLt:MinSqlMajorVersion](10)
CREATE PROCEDURE AssertEqualsTableTests.[test can handle hierarchyid data type]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can handle a datatype] 'HIERARCHYID', '''/10/'',''/11/'',''/12/''';
END;
GO
--[@tSQLt:MinSqlMajorVersion](10)
CREATE PROCEDURE AssertEqualsTableTests.[test all unsupported 2008 data types]
AS
BEGIN
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can NOT handle a datatype] 'GEOMETRY', 'geometry::STPointFromText(''POINT (10 10)'', 0),geometry::STPointFromText(''POINT (11 11)'', 0),geometry::STPointFromText(''POINT (12 12)'', 0)';
  EXEC AssertEqualsTableTests.[Assert that AssertEqualsTable can NOT handle a datatype] 'GEOGRAPHY', 'geography::STGeomFromText(''LINESTRING(-10.10 10.10, -50.10 50.10)'', 4326),geography::STGeomFromText(''LINESTRING(-11.11 11.11, -50.11 50.11)'', 4326),geography::STGeomFromText(''LINESTRING(-12.12 12.12, -50.12 50.12)'', 4326)';
END;
GO
/*-----------------------------------------------------------------------------------------------*/
GO
CREATE PROC AssertEqualsTableTests.[test RC table is marked as tSQLt.IsTempObject]
AS
BEGIN
  CREATE TABLE #Table1 (id INT);
  CREATE TABLE #Table2 (id INT);

  SELECT name,
         object_id,
         schema_id
    INTO #TableListBefore
    FROM sys.tables
   WHERE name LIKE 'tSQLt[_]tempobject[_]%';

  EXEC tSQLt.AssertEqualsTable '#Table1','#Table2';

  SELECT QUOTENAME(SCHEMA_NAME(NewTable.schema_id))+'.'+QUOTENAME(NewTable.name) TableName, EP.value AS [tSQLt.IsTempObject]
    INTO #Actual
    FROM(
      SELECT name, object_id, schema_id FROM sys.tables WHERE name LIKE 'tSQLt[_]tempobject[_]%'
      EXCEPT
      SELECT name, object_id, schema_id FROM #TableListBefore AS TLB
    ) NewTable
    LEFT JOIN sys.extended_properties EP
      ON EP.class_desc = 'OBJECT_OR_COLUMN'
     AND EP.name = 'tSQLt.IsTempObject'
     AND NewTable.object_id = EP.major_id

  SELECT TOP(0) A.* INTO #Expected FROM #Actual A RIGHT JOIN #Actual X ON 1=0;

  INSERT INTO #Expected SELECT TableName, 1 FROM #Actual;

  EXEC tSQLt.AssertEqualsTable '#Expected','#Actual';
END;
GO
/*-----------------------------------------------------------------------------------------------*/
GO
CREATE PROC AssertEqualsTableTests.[test RC table is created in the tSQLt schema]
AS
BEGIN
  CREATE TABLE #Table1 (id INT);
  CREATE TABLE #Table2 (id INT);

  SELECT name,
         object_id,
         schema_id
    INTO #TableListBefore
    FROM sys.tables
   WHERE name LIKE 'tSQLt[_]tempobject[_]%';

  EXEC tSQLt.AssertEqualsTable '#Table1','#Table2';

  SELECT SCHEMA_NAME(NewTable.schema_id) SchemaName, NewTable.name TableName
    INTO #Actual
    FROM(
      SELECT name, object_id, schema_id FROM sys.tables WHERE name LIKE 'tSQLt[_]tempobject[_]%'
      EXCEPT
      SELECT name, object_id, schema_id FROM #TableListBefore AS TLB
    ) NewTable

  SELECT TOP(0) A.* INTO #Expected FROM #Actual A RIGHT JOIN #Actual X ON 1=0;

  INSERT INTO #Expected SELECT 'tSQLt', TableName FROM #Actual;

  EXEC tSQLt.AssertEqualsTable '#Expected','#Actual';
END;
GO
/*-----------------------------------------------------------------------------------------------*/
GO
