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

CREATE PROCEDURE Test_SpyProcedure.Test_NewProcedureWithP1_DefaultValue
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure @P1 int = 1 AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.NewProcedure';

    EXEC dbo.NewProcedure;

    IF NOT EXISTS (SELECT 1 FROM dbo.NewProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 IS NULL)
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewProcedure_SpyProcedureLog should exists.';
    END
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_NewProcedureWithP1_Output
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure @P1 int OUTPUT AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.NewProcedure';

    DECLARE @P1 int = 1;
    EXEC dbo.NewProcedure @P1 = @P1 OUTPUT;

    IF NOT EXISTS (SELECT 1 FROM dbo.NewProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewProcedure_SpyProcedureLog should exists.';
    END
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_NewProcedureWithP1_CommandToExecute
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.NewProcedure @P1 int OUTPUT AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.NewProcedure', 'SET @P1 = 2;';

    DECLARE @P1 int = 1;
    EXEC dbo.NewProcedure @P1 = @P1 OUTPUT;

    IF NOT EXISTS (SELECT 1 FROM dbo.NewProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewProcedure_SpyProcedureLog should exists.';
    END

    EXEC tSQLt.AssertEquals 2, @P1, '@P1 should equals 2.';
END;
GO