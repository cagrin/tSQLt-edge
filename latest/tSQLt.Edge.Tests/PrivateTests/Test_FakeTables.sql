CREATE SCHEMA Test_FakeTables;
GO

CREATE PROCEDURE Test_FakeTables.Test_FakeTablesAfterFakeTable
AS
BEGIN
    EXEC('CREATE TABLE master.dbo.TestTable1 (Column1 int IDENTITY(1,2) NOT NULL, Column2 AS 2*Column1, Column3 VARCHAR(100) COLLATE Polish_100_CI_AS DEFAULT ''-'');');

    EXEC tSQLt.FakeTable 'master.dbo.TestTable1';

    SELECT
        ObjectName = '[master].[dbo].[TestTable1]'
    INTO #Expected

    SELECT
        ObjectName
    INTO #Actual
    FROM tSQLt.Private_FakeTables

    EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END;
GO