CREATE SCHEMA Test_FakeTable;
GO

CREATE PROCEDURE Test_FakeTable.Test_ColumnsAreNulls
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Column1 int NULL)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_IdentityFalse
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 int IDENTITY(1,2) NOT NULL)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Column1 int NULL)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_IdentityTrue
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 int IDENTITY(1,2) NOT NULL)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1', @Identity = 1;

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Column1 int IDENTITY(1,2) NOT NULL)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_ComputedFalse
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL, Column2 AS 2*Column1)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Column1 int NULL, Column2 int NULL)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_ComputedTrue
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL, Column2 AS 2*Column1)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1', @ComputedColumns = 1;

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Column1 int NULL, Column2 AS 2*Column1)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_ComputedFalsePersisted
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL, Column2 AS 2*Column1 PERSISTED)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Column1 int NULL, Column2 int NULL)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_ComputedTruePersisted
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL, Column2 AS 2*Column1 PERSISTED)');

    EXEC tSQLt.FakeTable 'dbo.TestTable1', @ComputedColumns = 1;

    EXEC ('CREATE TABLE dbo.ExpectedFakeTable1 (Column1 int NULL, Column2 AS 2*Column1 PERSISTED)');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.ExpectedFakeTable1', 'dbo.TestTable1';
END;
GO