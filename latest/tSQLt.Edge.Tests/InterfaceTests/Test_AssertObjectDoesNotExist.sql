CREATE SCHEMA Test_AssertObjectDoesNotExist;
GO

CREATE PROCEDURE Test_AssertObjectDoesNotExist.Test_NotExists
AS
BEGIN
    EXEC tSQLt.AssertObjectDoesNotExist 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertObjectDoesNotExist.Test_TempNotExists
AS
BEGIN
    EXEC tSQLt.AssertObjectDoesNotExist '#TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertObjectDoesNotExist.Test_DoesExist
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);

    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectDoesNotExist failed. Object:<dbo.TestTable1> does exist.';

    EXEC tSQLt.AssertObjectDoesNotExist 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertObjectDoesNotExist.Test_TempDoesExist
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 INT);

    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectDoesNotExist failed. Object:<#TestTable1> does exist.';

    EXEC tSQLt.AssertObjectDoesNotExist '#TestTable1';
END;
GO