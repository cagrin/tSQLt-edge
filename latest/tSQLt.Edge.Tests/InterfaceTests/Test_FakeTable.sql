CREATE SCHEMA Test_FakeTable;
GO

CREATE PROCEDURE Test_FakeTable.Test_ColumnsAreNulls
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Columns1 int NOT NULL)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Columns1 int NULL)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_IdentityFalse
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Columns1 int IDENTITY(1,2) NOT NULL)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Columns1 int NULL)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_IdentityTrue
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Columns1 int IDENTITY(1,2) NOT NULL)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1', @Identity = 1;

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Columns1 int IDENTITY(1,2) NOT NULL)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO