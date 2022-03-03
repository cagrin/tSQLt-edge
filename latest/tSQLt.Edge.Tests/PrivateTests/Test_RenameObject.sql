CREATE SCHEMA Test_RenameObject;
GO

CREATE PROCEDURE Test_RenameObject.Test_StoredProcedure
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure AS BEGIN RETURN; END;');

    DECLARE @ObjectId INT = OBJECT_ID('dbo.NewProcedure');
    EXEC tSQLt.Private_RenameObject @ObjectId;

    IF OBJECT_ID('dbo.NewProcedure') IS NOT NULL
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewProcedure should not exists.';
    END
END;
GO

CREATE PROCEDURE Test_RenameObject.Test_Table
AS
BEGIN
    EXEC ('CREATE TABLE dbo.NewTable (Id int);');

    DECLARE @ObjectId INT = OBJECT_ID('dbo.NewTable');
    EXEC tSQLt.Private_RenameObject @ObjectId;

    IF OBJECT_ID('dbo.NewTable') IS NOT NULL
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewTable should not exists.';
    END
END;
GO