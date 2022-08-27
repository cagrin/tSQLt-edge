CREATE SCHEMA Test_AssertEqualsTableSchema;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_TwoIdenticalTables
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_DifferentColumnNames
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column2 INT);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Column1] int NULL>. Actual:<[Column2] int NULL>.';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_ErrorMessage
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column2 INT);

    EXEC tSQLt.ExpectException 'Error message. tSQLt.AssertEqualsTableSchema failed. Expected:<[Column1] int NULL>. Actual:<[Column2] int NULL>.';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2', 'Error message.';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_DifferentColumnNullable
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT NOT NULL);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Column1] int NULL>. Actual:<[Column1] int NOT NULL>.';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_DifferentColumnCollation
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 VARCHAR(100));
    CREATE TABLE dbo.TestTable2 (Column1 VARCHAR(100) COLLATE Polish_100_CI_AS);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Column1] varchar(100) NULL>. Actual:<[Column1] varchar(100) COLLATE Polish_100_CI_AS NULL>.';

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_TempTables
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 INT);
    CREATE TABLE #TestTable2 (Column1 INT);

    EXEC tSQLt.AssertEqualsTableSchema '#TestTable1', '#TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_TempTablesFail
AS
BEGIN
    CREATE TABLE #TestTable1 (Id BIT PRIMARY KEY, NoKey NVARCHAR(MAX) NULL);
    CREATE TABLE #TestTable2 (Id INT PRIMARY KEY, NoKey INT NULL);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Id] bit NOT NULL, [NoKey] nvarchar(max) NULL>. Actual:<[Id] int NOT NULL, [NoKey] int NULL>.';

    EXEC tSQLt.AssertEqualsTableSchema '#TestTable1', '#TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_TempTablesOptionsFail
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 int IDENTITY(1,2) NOT NULL, Column2 AS 2*Column1, Column3 VARCHAR(100) COLLATE Polish_100_CI_AS DEFAULT '-');
    CREATE TABLE #TestTable2 (Column1 int,                        Column2 int         , Column3 VARCHAR(100) COLLATE Polish_100_CI_AS);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Column1] int IDENTITY(1,2) NOT NULL, [Column2] AS ((2)*[Column1]), [Column3] varchar(100) COLLATE Polish_100_CI_AS DEFAULT (''-'')>. Actual:<[Column1] int NULL, [Column2] int NULL, [Column3] varchar(100) COLLATE Polish_100_CI_AS NULL>.';

    EXEC tSQLt.AssertEqualsTableSchema '#TestTable1', '#TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_TempTables_ExpectedNotExists
AS
BEGIN
    CREATE TABLE #TestTable2 (Column1 INT);

    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<#TestTable1> does not exist.';

    EXEC tSQLt.AssertEqualsTableSchema '#TestTable1', '#TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_TempTables_ActualNotExists
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 INT);

    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<#TestTable2> does not exist.';

    EXEC tSQLt.AssertEqualsTableSchema '#TestTable1', '#TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_SameTypeWithDifferentSchema
AS
BEGIN
    EXEC('CREATE SCHEMA [Schema A]');
    EXEC('CREATE SCHEMA [Schema B]');
    EXEC('CREATE TABLE [Schema A].[Table A] (Column1 INT)');
    EXEC('CREATE TABLE [Schema B].[Table B] (Column1 INT)');

    EXEC tSQLt.AssertEqualsTableSchema '[Schema A].[Table A]', '[Schema B].[Table B]';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_UserTypeWithDifferentSchema
AS
BEGIN
    EXEC('CREATE SCHEMA [Schema A]');
    EXEC('CREATE SCHEMA [Schema B]');
    EXEC('CREATE TYPE [Schema A].[Test Type] FROM INT');
    EXEC('CREATE TYPE [Schema B].[Test Type] FROM INT');
    EXEC('CREATE TABLE [Schema A].[Table A] (Column1 [Schema A].[Test Type])');
    EXEC('CREATE TABLE [Schema B].[Table B] (Column1 [Schema B].[Test Type])');

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTableSchema failed. Expected:<[Column1] [Schema A].[Test Type] NULL>. Actual:<[Column1] [Schema B].[Test Type] NULL>.';

    EXEC tSQLt.AssertEqualsTableSchema '[Schema A].[Table A]', '[Schema B].[Table B]';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_CanDoView
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);

    EXEC ('CREATE VIEW dbo.TestView1 AS SELECT * FROM dbo.TestTable1;')
    EXEC ('CREATE VIEW dbo.TestView2 AS SELECT * FROM dbo.TestTable2;')

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestView1', 'dbo.TestView2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_CanDoSynonymForTable
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);

    EXEC ('CREATE SYNONYM dbo.TestSynonym1 FOR dbo.TestTable1;')
    EXEC ('CREATE SYNONYM dbo.TestSynonym2 FOR dbo.TestTable2;')

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestSynonym1', 'dbo.TestSynonym2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_CanDoSynonymForView
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);

    EXEC ('CREATE VIEW dbo.TestView1 AS SELECT * FROM dbo.TestTable1;')
    EXEC ('CREATE VIEW dbo.TestView2 AS SELECT * FROM dbo.TestTable2;')

    EXEC ('CREATE SYNONYM dbo.TestSynonym1 FOR dbo.TestView1;')
    EXEC ('CREATE SYNONYM dbo.TestSynonym2 FOR dbo.TestView2;')

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestSynonym1', 'dbo.TestSynonym2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_ExternalTables
AS
BEGIN
    CREATE TABLE master.dbo.TestTable1 (Column1 INT);
    CREATE TABLE master.dbo.TestTable2 (Column1 INT);

    EXEC tSQLt.AssertEqualsTableSchema 'master.dbo.TestTable1', 'master.dbo.TestTable2';
END;
GO