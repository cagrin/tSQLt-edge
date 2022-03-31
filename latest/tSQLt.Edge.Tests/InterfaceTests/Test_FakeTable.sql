CREATE SCHEMA Test_FakeTable;
GO

CREATE PROCEDURE Test_FakeTable.Test_ColumnsAreNulls
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL);
    CREATE TABLE dbo.TestTable2 (Column1 int NULL);

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_IdentityFalse
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int IDENTITY(1,2) NOT NULL);
    CREATE TABLE dbo.TestTable2 (Column1 int NULL);

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_IdentityTrue
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int IDENTITY(1,2) NOT NULL);
    CREATE TABLE dbo.TestTable2 (Column1 int IDENTITY(1,2) NOT NULL);

    EXEC tSQLt.FakeTable 'dbo.TestTable1', @Identity = 1;

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_ComputedFalse
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL, Column2 AS 2*Column1);
    CREATE TABLE dbo.TestTable2 (Column1 int NULL,     Column2 int NULL);

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_ComputedTrue
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL, Column2 AS 2*Column1);
    CREATE TABLE dbo.TestTable2 (Column1 int NULL,     Column2 AS 2*Column1);

    EXEC tSQLt.FakeTable 'dbo.TestTable1', @ComputedColumns = 1;

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_ComputedFalsePersisted
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL, Column2 AS 2*Column1 PERSISTED);
    CREATE TABLE dbo.TestTable2 (Column1 int NULL,     Column2 int NULL);

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_ComputedTruePersisted
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL, Column2 AS 2*Column1 PERSISTED);
    CREATE TABLE dbo.TestTable2 (Column1 int NULL,     Column2 AS 2*Column1 PERSISTED);

    EXEC tSQLt.FakeTable 'dbo.TestTable1', @ComputedColumns = 1;

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_DefaultFalse
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int DEFAULT 1);
    CREATE TABLE dbo.TestTable2 (Column1 int NULL);

    EXEC tSQLt.FakeTable 'dbo.TestTable1';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_DefaultTrue
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int DEFAULT 1);
    CREATE TABLE dbo.TestTable2 (Column1 int DEFAULT 1);

    EXEC tSQLt.FakeTable 'dbo.TestTable1', @Defaults = 1;

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestTable1';
END;
GO