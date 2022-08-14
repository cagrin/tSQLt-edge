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

CREATE PROCEDURE Test_AssertObjectDoesNotExist.Test_ErrorMessage
AS
BEGIN
    CREATE TABLE dbo.TestTable1 (Column1 INT);

    EXEC tSQLt.ExpectException 'Error message. tSQLt.AssertObjectDoesNotExist failed. Object:<dbo.TestTable1> does exist.';

    EXEC tSQLt.AssertObjectDoesNotExist 'dbo.TestTable1', 'Error message.';
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

CREATE PROCEDURE Test_AssertObjectDoesNotExist.Test_ExternalNotExists
AS
BEGIN
    EXEC tSQLt.AssertObjectDoesNotExist 'master.dbo.TestTable1';
END;
GO

CREATE PROCEDURE Test_AssertObjectDoesNotExist.Test_ExternalDoesExist
AS
BEGIN
    CREATE TABLE master.dbo.TestTable1 (Column1 INT);

    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectDoesNotExist failed. Object:<master.dbo.TestTable1> does exist.';

    EXEC tSQLt.AssertObjectDoesNotExist 'master.dbo.TestTable1';
END;
GO