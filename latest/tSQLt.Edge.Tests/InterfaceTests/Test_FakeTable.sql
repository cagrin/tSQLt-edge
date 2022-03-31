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

CREATE PROCEDURE Test_FakeTable.Test_PreserveOnlyCollation
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int IDENTITY(1,2) NOT NULL, Column2 AS 2*Column1, Column3 VARCHAR(100) COLLATE Polish_100_CI_AS DEFAULT '-');
    CREATE TABLE dbo.TestTable2 (Column1 int,                        Column2 int         , Column3 VARCHAR(100) COLLATE Polish_100_CI_AS);

    EXEC tSQLt.FakeTable 'dbo.TestTable1', @Identity = 0, @ComputedColumns = 0, @Defaults = 0;

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_CanFakeTempTable
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 int IDENTITY(1,2) NOT NULL, Column2 AS 2*Column1, Column3 VARCHAR(100) COLLATE Polish_100_CI_AS DEFAULT '-');
    CREATE TABLE #TestTable2 (Column1 int,                        Column2 int         , Column3 VARCHAR(100) COLLATE Polish_100_CI_AS);

    -- Not implemented.
    EXEC tSQLt.ExpectException 'Either the parameter @objname is ambiguous or the claimed @objtype (OBJECT) is wrong.'

    EXEC tSQLt.FakeTable '#TestTable1';

    EXEC tSQLt.AssertEqualsTableSchema '#TestTable2', '#TestTable1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_CanFakeView
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int IDENTITY(1,2) NOT NULL, Column2 AS 2*Column1, Column3 VARCHAR(100) COLLATE Polish_100_CI_AS DEFAULT '-');
    CREATE TABLE dbo.TestTable2 (Column1 int,                        Column2 int         , Column3 VARCHAR(100) COLLATE Polish_100_CI_AS);

    EXEC ('CREATE VIEW dbo.TestView1 AS SELECT * FROM dbo.TestTable1;')

    EXEC tSQLt.FakeTable 'dbo.TestView1';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestView1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_CanFakeSynonymForTable
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int IDENTITY(1,2) NOT NULL, Column2 AS 2*Column1, Column3 VARCHAR(100) COLLATE Polish_100_CI_AS DEFAULT '-');
    CREATE TABLE dbo.TestTable2 (Column1 int,                        Column2 int         , Column3 VARCHAR(100) COLLATE Polish_100_CI_AS);

    EXEC ('CREATE SYNONYM dbo.TestSynonym1 FOR dbo.TestTable1;')

    EXEC tSQLt.FakeTable 'dbo.TestSynonym1';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestSynonym1';
END;
GO

CREATE PROCEDURE Test_FakeTable.Test_CanFakeSynonymForView
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int IDENTITY(1,2) NOT NULL, Column2 AS 2*Column1, Column3 VARCHAR(100) COLLATE Polish_100_CI_AS DEFAULT '-');
    CREATE TABLE dbo.TestTable2 (Column1 int,                        Column2 int         , Column3 VARCHAR(100) COLLATE Polish_100_CI_AS);

    EXEC ('CREATE VIEW dbo.TestView1 AS SELECT * FROM dbo.TestTable1;')
    EXEC ('CREATE SYNONYM dbo.TestSynonym1 FOR dbo.TestView1;')

    EXEC tSQLt.FakeTable 'dbo.TestSynonym1';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable2', 'dbo.TestSynonym1';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_SchemaName
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 int NOT NULL);

    EXEC tSQLt.ExpectException '@SchemaName parameter preserved for backward compatibility. Do not use. Will be removed soon.';

    EXEC tSQLt.FakeTable @TableName = 'TestTable1', @SchemaName = 'dbo';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_TableNameIsNull
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<(null)> does not exist.';

    EXEC tSQLt.FakeTable NULL;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_TableNameNotExists
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<dbo.TestTable1> does not exist.';

    EXEC tSQLt.FakeTable 'dbo.TestTable1';
END;
GO