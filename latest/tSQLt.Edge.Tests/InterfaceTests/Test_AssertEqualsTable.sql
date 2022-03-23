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

    EXEC tSQLt.AssertEqualsTable '#TestTable1', '#TestTable2';
END;
GO