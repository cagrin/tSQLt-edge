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

    -- Not implemented.
    EXEC tSQLt.ExpectException 'Either the parameter @objname is ambiguous or the claimed @objtype (OBJECT) is wrong.'

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

CREATE PROCEDURE Test_RemoveObject.Test_NewNameIsEmpty
AS
BEGIN
    EXEC ('CREATE TABLE dbo.NewTable (Id int);');

    DECLARE @NewName NVARCHAR(MAX);

    EXEC tSQLt.RemoveObject 'dbo.NewTable', @NewName OUTPUT;

    EXEC tSQLt.AssertNotEqualsString NULL, @NewName;
END;
GO

CREATE PROCEDURE Test_RemoveObject.Test_NewNameIsNotEmpty
AS
BEGIN
    EXEC ('CREATE TABLE dbo.NewTable (Id int);');

    DECLARE @NewName NVARCHAR(MAX) = 'NewName';

    EXEC tSQLt.RemoveObject 'dbo.NewTable', @NewName OUTPUT;

    EXEC tSQLt.AssertEqualsString '[dbo].[NewName]', @NewName;
END;
GO

CREATE PROCEDURE Test_RemoveObject.Test_ExternalTable
AS
BEGIN
    EXEC ('CREATE TABLE master.dbo.NewTable (Id int);');

    EXEC tSQLt.RemoveObject 'master.dbo.NewTable';

    EXEC tSQLt.AssertObjectDoesNotExist 'master.dbo.NewTable';
END;
GO

CREATE PROCEDURE Test_RemoveObject.Test_ExternalTableNewName
AS
BEGIN
    EXEC ('CREATE TABLE master.dbo.NewTable (Id int);');

    DECLARE @NewName NVARCHAR(MAX);

    EXEC tSQLt.RemoveObject 'master.dbo.NewTable', @NewName OUTPUT;

    EXEC tSQLt.AssertLike '[[]master_.[[]dbo_.[[]________-____-____-____-_____________', @NewName;
END;
GO