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
    EXEC tSQLt.ExpectException 'Invalid object name ''dbo.TestTable1''.';

    EXEC tSQLt.AssertEmptyTable 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_NonExistsTempTable
AS
BEGIN
    EXEC tSQLt.ExpectException 'Invalid object name ''#TestTable1''.';

    EXEC tSQLt.AssertEmptyTable '#TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertEmptyTable.Test_NullCommand
AS
BEGIN
    EXEC tSQLt.ExpectException 'Incorrect syntax near '')''.';

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