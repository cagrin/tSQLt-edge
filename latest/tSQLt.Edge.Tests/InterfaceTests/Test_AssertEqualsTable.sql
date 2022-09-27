CREATE SCHEMA Test_AssertEqualsTable;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_TwoEmptyTables
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_TwoIdenticalRows
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (1);

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_FirstTableIsNotEmpty
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTable failed. Expected:<dbo.TestTable1> has different rowset than Actual:<dbo.TestTable2>.';

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_ErrorMessage
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);

    EXEC tSQLt.ExpectException 'Error message. tSQLt.AssertEqualsTable failed. Expected:<dbo.TestTable1> has different rowset than Actual:<dbo.TestTable2>.';

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2', 'Error message.';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_SecondTableIsNotEmpty
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (1);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTable failed. Expected:<dbo.TestTable1> has different rowset than Actual:<dbo.TestTable2>.';

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_FirstTableHasTwinRows
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (1);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTable failed. Expected:<dbo.TestTable1> has different rowset than Actual:<dbo.TestTable2>.';

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_SecondTableHasTwinRows
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (1);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (1);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTable failed. Expected:<dbo.TestTable1> has different rowset than Actual:<dbo.TestTable2>.';

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_SameRowsDifferentOrder
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (2);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (3);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (3);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (2);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (1);

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_TwoColumnsTwoRows
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 BIGINT, Column2 CHAR(3));
    CREATE TABLE dbo.TestTable2 (Column1 INT, Column2 VARCHAR(3));
    INSERT INTO dbo.TestTable1 VALUES (1, 'ABC');
    INSERT INTO dbo.TestTable1 VALUES (2, 'XYZ');
    INSERT INTO dbo.TestTable2 VALUES (1, 'ABC');
    INSERT INTO dbo.TestTable2 VALUES (2, 'XYZ');

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_TwoColumnsTwoNulls
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 BIGINT, Column2 CHAR(3));
    CREATE TABLE dbo.TestTable2 (Column1 INT, Column2 VARCHAR(3));
    INSERT INTO dbo.TestTable1 VALUES (NULL, NULL);
    INSERT INTO dbo.TestTable2 VALUES (NULL, NULL);

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_TempTables
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 INT);
    CREATE TABLE #TestTable2 (Column1 INT);
    INSERT INTO #TestTable1 (Column1) VALUES (1);
    INSERT INTO #TestTable2 (Column1) VALUES (1);

    EXEC tSQLt.AssertEqualsTable '#TestTable1', '#TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_TempTables_ExpectedNotExists
AS
BEGIN
    CREATE TABLE #TestTable2 (Column1 INT);

    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<#TestTable1> does not exist.';

    EXEC tSQLt.AssertEqualsTable '#TestTable1', '#TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_TempTables_ActualNotExists
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 INT);

    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<#TestTable2> does not exist.';

    EXEC tSQLt.AssertEqualsTable '#TestTable1', '#TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_CanDoView
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (1);

    EXEC ('CREATE VIEW dbo.TestView1 AS SELECT * FROM dbo.TestTable1;')
    EXEC ('CREATE VIEW dbo.TestView2 AS SELECT * FROM dbo.TestTable2;')

    EXEC tSQLt.AssertEqualsTable 'dbo.TestView1', 'dbo.TestView2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_CanDoSynonymForTable
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (1);

    EXEC ('CREATE SYNONYM dbo.TestSynonym1 FOR dbo.TestTable1;')
    EXEC ('CREATE SYNONYM dbo.TestSynonym2 FOR dbo.TestTable2;')

    EXEC tSQLt.AssertEqualsTable 'dbo.TestSynonym1', 'dbo.TestSynonym2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_CanDoSynonymForView
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);
    CREATE TABLE dbo.TestTable2 (Column1 INT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (1);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (1);

    EXEC ('CREATE VIEW dbo.TestView1 AS SELECT * FROM dbo.TestTable1;')
    EXEC ('CREATE VIEW dbo.TestView2 AS SELECT * FROM dbo.TestTable2;')

    EXEC ('CREATE SYNONYM dbo.TestSynonym1 FOR dbo.TestView1;')
    EXEC ('CREATE SYNONYM dbo.TestSynonym2 FOR dbo.TestView2;')

    EXEC tSQLt.AssertEqualsTable 'dbo.TestSynonym1', 'dbo.TestSynonym2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_LowDate
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (DateColumn DATE);
    CREATE TABLE dbo.TestTable2 (DateColumn DATE);
    INSERT INTO dbo.TestTable1 (DateColumn) VALUES ('1752-12-31');
    INSERT INTO dbo.TestTable2 (DateColumn) VALUES ('2000-01-01');

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTable failed. Expected:<dbo.TestTable1> has different rowset than Actual:<dbo.TestTable2>.';

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_MinDate
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (DateColumn DATE);
    CREATE TABLE dbo.TestTable2 (DateColumn DATE);
    INSERT INTO dbo.TestTable1 (DateColumn) VALUES ('0001-01-01');
    INSERT INTO dbo.TestTable2 (DateColumn) VALUES ('0001-01-01');

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_XmlComparison
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 XML);
    CREATE TABLE dbo.TestTable2 (Column1 XML);
    INSERT INTO dbo.TestTable1 (Column1) VALUES ('<Node1/>');
    INSERT INTO dbo.TestTable2 (Column1) VALUES ('<Node1/>');

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_XmlComparisonToString
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 XML);
    CREATE TABLE dbo.TestTable2 (Column1 NVARCHAR(MAX));
    INSERT INTO dbo.TestTable1 (Column1) VALUES ('<Node1></Node1>');
    INSERT INTO dbo.TestTable2 (Column1) VALUES ('<Node1/>');

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_UncomparableDataTypes
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 TEXT, Column2 NTEXT, Column3 IMAGE);
    CREATE TABLE dbo.TestTable2 (Column1 TEXT, Column2 NTEXT, Column3 IMAGE);

    EXEC tSQLt.ExpectException 'The text, ntext, and image data types cannot be compared or sorted, except when using IS NULL or LIKE operator.';

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_ExternalTables
AS
BEGIN
    EXEC ('CREATE TABLE master.dbo.TestTable1 (Column1 INT);');
    EXEC ('CREATE TABLE master.dbo.TestTable2 (Column1 INT);');
    EXEC ('INSERT INTO master.dbo.TestTable1 (Column1) VALUES (1);');
    EXEC ('INSERT INTO master.dbo.TestTable2 (Column1) VALUES (1);');

    EXEC tSQLt.AssertEqualsTable 'master.dbo.TestTable1', 'master.dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTable.Test_FloatLossOfPrecision
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 FLOAT);
    CREATE TABLE dbo.TestTable2 (Column1 FLOAT);
    INSERT INTO dbo.TestTable1 (Column1) VALUES (0.1);
    UPDATE dbo.TestTable1 SET Column1 = Column1+(0.2);
    INSERT INTO dbo.TestTable2 (Column1) VALUES (0.3);

    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsTable failed. Expected:<dbo.TestTable1> has different rowset than Actual:<dbo.TestTable2>.';

    EXEC tSQLt.AssertEqualsTable 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO