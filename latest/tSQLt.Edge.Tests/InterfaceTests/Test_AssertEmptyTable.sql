CREATE SCHEMA Test_AssertEmptyTable;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_EmptyTable
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);

    EXEC tSQLt.AssertEmptyTable 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_EmptyTempTable
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 INT);

    EXEC tSQLt.AssertEmptyTable '#TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_NonExistsTable
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<dbo.TestTable1> does not exist.';

    EXEC tSQLt.AssertEmptyTable 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_NonExistsTempTable
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<#TestTable1> does not exist.';

    EXEC tSQLt.AssertEmptyTable '#TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_NullCommand
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<(null)> does not exist.';

    EXEC tSQLt.AssertEmptyTable NULL;
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_NonEmptyTable
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEmptyTable failed. Expected:<dbo.TestTable1> is not empty.';

    EXEC tSQLt.AssertEmptyTable 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_ErrorMessage
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);

    EXEC tSQLt.ExpectException 'Error message. tSQLt.AssertEmptyTable failed. Expected:<dbo.TestTable1> is not empty.';

    EXEC tSQLt.AssertEmptyTable 'dbo.TestTable1', 'Error message.';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_NonEmptyTempTable
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 INT);
    INSERT INTO #TestTable1 (Column1) VALUES (1);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEmptyTable failed. Expected:<#TestTable1> is not empty.';

    EXEC tSQLt.AssertEmptyTable '#TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_CanDoView
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);

    EXEC ('CREATE VIEW dbo.TestView1 AS SELECT * FROM dbo.TestTable1;')

    EXEC tSQLt.AssertEmptyTable 'dbo.TestView1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_CanDoSynonymForTable
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);

    EXEC ('CREATE SYNONYM dbo.TestSynonym1 FOR dbo.TestTable1;')

    EXEC tSQLt.AssertEmptyTable 'dbo.TestSynonym1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_CanDoSynonymForView
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);

    EXEC ('CREATE VIEW dbo.TestView1 AS SELECT * FROM dbo.TestTable1;')
    EXEC ('CREATE SYNONYM dbo.TestSynonym1 FOR dbo.TestView1;')

    EXEC tSQLt.AssertEmptyTable 'dbo.TestSynonym1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_QuotedEmptyTable
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);

    EXEC tSQLt.AssertEmptyTable '[dbo].[TestTable1]';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_QuotedEmptyTempTable
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 INT);

    EXEC tSQLt.AssertEmptyTable '[#TestTable1]';
END;
GO