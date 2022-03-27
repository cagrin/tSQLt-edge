CREATE SCHEMA Test_RenameObject;
GO

CREATE PROCEDURE Test_RenameObject.Test_StoredProcedure
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure AS BEGIN RETURN; END;');

    DECLARE @ObjectId INT = OBJECT_ID('dbo.NewProcedure');
    EXEC tSQLt.Private_RenameObject @ObjectId;

    EXEC tSQLt.AssertObjectDoesNotExist 'dbo.NewProcedure';
END;
GO

CREATE PROCEDURE Test_RenameObject.Test_Table
AS
BEGIN
    EXEC ('CREATE TABLE dbo.NewTable (Id int);');

    DECLARE @ObjectId INT = OBJECT_ID('dbo.NewTable');
    EXEC tSQLt.Private_RenameObject @ObjectId;

    EXEC tSQLt.AssertObjectDoesNotExist 'dbo.NewTable';
END;
GO

CREATE PROCEDURE Test_RenameObject.Test_Table_WithNewNameIsNull
AS
BEGIN
    EXEC ('CREATE TABLE dbo.NewTable (Id int);');

    DECLARE @ObjectId INT = OBJECT_ID('dbo.NewTable');
    DECLARE @NewName NVARCHAR(MAX);
    EXEC tSQLt.Private_RenameObject @ObjectId, @NewName OUTPUT;

    EXEC tSQLt.AssertObjectExists @NewName;
END;
GO

CREATE PROCEDURE Test_RenameObject.Test_Table_WithNewNameIsNewId
AS
BEGIN
    EXEC ('CREATE TABLE dbo.NewTable (Id int);');

    DECLARE @ObjectId INT = OBJECT_ID('dbo.NewTable');
    DECLARE @NewName NVARCHAR(MAX) = NEWID();
    EXEC tSQLt.Private_RenameObject @ObjectId, @NewName OUTPUT;

    EXEC tSQLt.AssertObjectExists @NewName;
END;
GO