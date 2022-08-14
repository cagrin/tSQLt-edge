CREATE SCHEMA Test_AssertObjectExists;
GO

CREATE PROCEDURE Test_AssertObjectExists.Test_DoesExists
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);

    EXEC tSQLt.AssertObjectExists 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertObjectExists.Test_TempDoesExists
AS
BEGIN
    CREATE TABLE #TestTable1 (Column1 INT);

    EXEC tSQLt.AssertObjectExists '#TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertObjectExists.Test_DoesNotExist
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<dbo.TestTable1> does not exist.';

    EXEC tSQLt.AssertObjectExists 'dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertObjectExists.Test_ErrorMessage
AS
BEGIN
    EXEC tSQLt.ExpectException 'Error message. tSQLt.AssertObjectExists failed. Object:<dbo.TestTable1> does not exist.';

    EXEC tSQLt.AssertObjectExists 'dbo.TestTable1', 'Error message.';
END;
GO

CREATE PROCEDURE Test_AssertObjectExists.Test_TempDoesNotExist
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<#TestTable1> does not exist.';

    EXEC tSQLt.AssertObjectExists '#TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertObjectExists.Test_ExternalDoesExists
AS
BEGIN
    CREATE TABLE master.dbo.TestTable1 (Column1 INT);

    EXEC tSQLt.AssertObjectExists 'master.dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertObjectExists.Test_ExternalDoesNotExist
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<master.dbo.TestTable1> does not exist.';

    EXEC tSQLt.AssertObjectExists 'master.dbo.TestTable1';
END;
GO