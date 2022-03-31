CREATE SCHEMA Test_RemoveObject;
GO

CREATE PROCEDURE Test_RemoveObject.Test_StoredProcedure
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure AS BEGIN RETURN; END;');

    EXEC tSQLt.RemoveObject 'dbo.NewProcedure';

    EXEC tSQLt.AssertObjectDoesNotExist 'dbo.NewProcedure';
END;
GO

CREATE PROCEDURE Test_RemoveObject.Test_Table
AS
BEGIN
    EXEC ('CREATE TABLE dbo.NewTable (Id int);');

    EXEC tSQLt.RemoveObject 'dbo.NewTable';

    EXEC tSQLt.AssertObjectDoesNotExist 'dbo.NewTable';
END;
GO

CREATE PROCEDURE Test_RemoveObject.Test_TempTable
AS
BEGIN
    CREATE TABLE #NewTable (Id int);

    EXEC tSQLt.RemoveObject '#NewTable';

    EXEC tSQLt.AssertObjectDoesNotExist '#NewTable';
END;
GO

CREATE PROCEDURE Test_RemoveObject.Test_Table_NotExists
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.RemoveObject failed. ObjectName:<dbo.NewTable> does not exist.'

    EXEC tSQLt.RemoveObject 'dbo.NewTable';
END;
GO

CREATE PROCEDURE Test_RemoveObject.Test_Table_IfExists
AS
BEGIN
    EXEC tSQLt.RemoveObject 'dbo.NewTable', @IfExists = 1;
END;
GO