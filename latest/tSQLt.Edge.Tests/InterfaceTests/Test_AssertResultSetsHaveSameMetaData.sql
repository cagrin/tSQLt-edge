CREATE SCHEMA Test_AssertResultSetsHaveSameMetaData;
GO

CREATE PROCEDURE Test_AssertResultSetsHaveSameMetaData.Test_Select1
AS
BEGIN
    EXEC tSQLt.AssertResultSetsHaveSameMetaData 'SELECT 1 Column1', 'SELECT 1 Column1';
END;
GO

CREATE PROC Test_AssertResultSetsHaveSameMetaData.Test_ActualCommandIsNull
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertResultSetsHaveSameMetaData failed. Expected:<[Column1] int NOT NULL> has different metadata than Actual:<(null)>.';

    EXEC tSQLt.AssertResultSetsHaveSameMetaData 'SELECT 1 Column1', NULL;
END;
GO

CREATE PROC Test_AssertResultSetsHaveSameMetaData.Test_ExpectedCommandIsNull
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertResultSetsHaveSameMetaData failed. Expected:<(null)> has different metadata than Actual:<[Column1] int NOT NULL>.';

    EXEC tSQLt.AssertResultSetsHaveSameMetaData NULL, 'SELECT 1 Column1';
END;
GO

CREATE PROCEDURE Test_AssertResultSetsHaveSameMetaData.Test_SelectMissingTemp
AS
BEGIN
    EXEC tSQLt.ExpectException 'Invalid object name ''#TestTable2''.';

    EXEC tSQLt.AssertResultSetsHaveSameMetaData 'SELECT 1 Column1', 'SELECT * FROM #TestTable2';
END;
GO

CREATE PROC Test_AssertResultSetsHaveSameMetaData.Test_SelectDivideBy0
AS
BEGIN
    EXEC tSQLt.ExpectException 'Divide by zero error encountered.';

    EXEC tSQLt.AssertResultSetsHaveSameMetaData 'SELECT 1 Column1', 'SELECT 1/0 Column1';
END;
GO

CREATE PROC Test_AssertResultSetsHaveSameMetaData.Test_SelectIntBigint
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertResultSetsHaveSameMetaData failed. Expected:<[Column1] int NULL> has different metadata than Actual:<[Column1] bigint NULL>.';

    EXEC tSQLt.AssertResultSetsHaveSameMetaData 'SELECT CAST(1 AS INT) Column1', 'SELECT CAST(1 AS BIGINT) Column1';
END;
GO

CREATE PROCEDURE Test_AssertResultSetsHaveSameMetaData.Test_SelectFromTemp
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 INT, Column2 CHAR(3));
    CREATE TABLE #TestTable2 (Column1 INT, Column2 CHAR(3));
    INSERT INTO #TestTable1 VALUES (1, 'ABC');
    INSERT INTO #TestTable2 VALUES (2, 'XYZ');

    EXEC tSQLt.AssertResultSetsHaveSameMetaData 'SELECT * FROM #TestTable1', 'SELECT * FROM #TestTable2';
END;
GO