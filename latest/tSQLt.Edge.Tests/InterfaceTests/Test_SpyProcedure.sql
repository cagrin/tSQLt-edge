CREATE SCHEMA Test_SpyProcedure;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_NewProcedure
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.NewProcedure';

    EXEC dbo.NewProcedure;

    IF NOT EXISTS (SELECT 1 FROM dbo.NewProcedure_SpyProcedureLog WHERE _id_ = 1)
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

    EXEC dbo.NewProcedure @P1 = 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.NewProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewProcedure_SpyProcedureLog should exists.';
    END
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_NewProcedureWithP1_P2_Output
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure @P1 char(1), @P2 int OUTPUT AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.NewProcedure';

    DECLARE @P2 int = 2;
    EXEC dbo.NewProcedure @P1 = '1', @P2 = @P2 OUTPUT;

    IF NOT EXISTS (SELECT 1 FROM dbo.NewProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = '1' AND P2 = 2)
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewProcedure_SpyProcedureLog should exists.';
    END
END;
GO