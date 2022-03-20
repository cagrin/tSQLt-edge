CREATE SCHEMA Test_AssertEqualsTableSchema;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_TwoIdenticalTables
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 INT);');
    EXEC ('CREATE TABLE dbo.TestTable2 (Column1 INT);');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_DifferentColumnNames
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 INT);');
    EXEC ('CREATE TABLE dbo.TestTable2 (Column2 INT);');

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Column1] int NULL>. Actual:<[Column2] int NULL>.';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_DifferentColumnNullable
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 INT);');
    EXEC ('CREATE TABLE dbo.TestTable2 (Column1 INT NOT NULL);');

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Column1] int NULL>. Actual:<[Column1] int NOT NULL>.';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_DifferentColumnCollation
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 VARCHAR(100));');
    EXEC ('CREATE TABLE dbo.TestTable2 (Column1 VARCHAR(100) COLLATE Polish_100_CI_AS);');

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Column1] varchar(100) NULL>. Actual:<[Column1] varchar(100) COLLATE Polish_100_CI_AS NULL>.';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO