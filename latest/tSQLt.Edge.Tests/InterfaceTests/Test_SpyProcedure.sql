CREATE SCHEMA Test_SpyProcedure;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_Procedure
AS
BEGIN
    EXEC ('CREATE OR ALTER PROCEDURE dbo.TestProcedure AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    EXEC dbo.TestProcedure;

    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1)
    BEGIN
        EXEC tSQLt.Fail 'dbo.TestProcedure_SpyProcedureLog should exists.';
    END
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1
AS
BEGIN
    EXEC ('CREATE OR ALTER PROCEDURE dbo.TestProcedure @P1 int AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    EXEC dbo.TestProcedure @P1 = 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail 'dbo.TestProcedure_SpyProcedureLog should exists.';
    END
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_DefaultValue
AS
BEGIN
    EXEC ('CREATE OR ALTER PROCEDURE dbo.TestProcedure @P1 int = 1 AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    EXEC dbo.TestProcedure;

    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 IS NULL)
    BEGIN
        EXEC tSQLt.Fail 'dbo.TestProcedure_SpyProcedureLog should exists.';
    END
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_Output
AS
BEGIN
    EXEC ('CREATE OR ALTER PROCEDURE dbo.TestProcedure @P1 int OUTPUT AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    DECLARE @P1 int = 1;
    EXEC dbo.TestProcedure @P1 = @P1 OUTPUT;

    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail 'dbo.TestProcedure_SpyProcedureLog should exists.';
    END
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_CommandToExecute
AS
BEGIN
    EXEC ('CREATE OR ALTER PROCEDURE dbo.TestProcedure @P1 int OUTPUT AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure', 'SET @P1 = 2;';

    DECLARE @P1 int = 1;
    EXEC dbo.TestProcedure @P1 = @P1 OUTPUT;

    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail 'dbo.TestProcedure_SpyProcedureLog should exists.';
    END

    EXEC tSQLt.AssertEquals 2, @P1, '@P1 should equals 2.';
END;
GO