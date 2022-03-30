CREATE SCHEMA Test_FakeTable;
GO

CREATE PROCEDURE Test_FakeTable.Test_ColumnsToNulls
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Columns1 int NOT NULL)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Columns1 int NULL)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO