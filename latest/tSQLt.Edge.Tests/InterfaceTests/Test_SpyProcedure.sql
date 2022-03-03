CREATE SCHEMA Test_SpyProcedure;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_NewProcedure
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.NewProcedure';

    EXEC ('EXEC dbo.NewProcedure');

    IF OBJECT_ID ('dbo.NewProcedure_SpyProcedureLog', 'U') IS NULL
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewProcedure_SpyProcedureLog should exists.';
    END
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_NewProcedureWithP1
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure @P1 int AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.NewProcedure';

    EXEC ('EXEC dbo.NewProcedure @P1 = 0;');

    IF OBJECT_ID ('dbo.NewProcedure_SpyProcedureLog', 'U') IS NULL
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewProcedure_SpyProcedureLog should exists.';
    END
END;
GO