CREATE SCHEMA Test_RemoveObject;
GO

CREATE PROCEDURE Test_RemoveObject.Test_StoredProcedure
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure AS BEGIN RETURN; END;');

    EXEC tSQLt.RemoveObject 'dbo.NewProcedure';

    IF OBJECT_ID('dbo.NewProcedure') IS NOT NULL
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewProcedure should not exists.';
    END
END;
GO

CREATE PROCEDURE Test_RemoveObject.Test_Table
AS
BEGIN
    EXEC ('CREATE TABLE dbo.NewTable (Id int);');

    EXEC tSQLt.RemoveObject 'dbo.NewTable';

    IF OBJECT_ID('dbo.NewTable') IS NOT NULL
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewTable should not exists.';
    END
END;
GO