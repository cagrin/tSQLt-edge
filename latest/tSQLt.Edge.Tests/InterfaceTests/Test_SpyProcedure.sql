CREATE SCHEMA Test_SpyProcedure;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_NewProcedure
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.NewProcedure';

    EXEC ('EXEC dbo.NewProcedure');
END;
GO