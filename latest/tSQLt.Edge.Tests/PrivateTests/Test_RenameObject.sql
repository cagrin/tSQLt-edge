CREATE SCHEMA Test_RenameObject;
GO

CREATE PROCEDURE Test_RenameObject.Test_StoredProcedure
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'CREATE PROCEDURE dbo.NewProcedure AS BEGIN RETURN 0; END;';
    EXEC (@Command);

    DECLARE @ObjectId INT = OBJECT_ID('dbo.NewProcedure');
    EXEC tSQLt.Private_RenameObject @ObjectId;

    IF OBJECT_ID('dbo.NewProcedure') IS NOT NULL
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewProcedure should not exists.';
    END
END;
GO