CREATE SCHEMA Test_SpyProcedure;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureLog
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    EXEC tSQLt.AssertObjectExists 'dbo.TestProcedure_SpyProcedureLog';
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_Procedure
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    EXEC ('EXEC dbo.TestProcedure;');

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1)
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_AllWeirdName
AS
BEGIN
    EXEC ('CREATE SCHEMA [O''clock.Schema]');
    EXEC ('CREATE PROCEDURE [O''clock.Schema].[O''clock.Procedure] AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure '[O''clock.Schema].[O''clock.Procedure]';

    EXEC ('EXEC [O''clock.Schema].[O''clock.Procedure];');

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM [O''clock.Schema].[O''clock.Procedure_SpyProcedureLog] WHERE _id_ = 1)
    BEGIN
        EXEC tSQLt.Fail ''[O''''clock.Schema].[O''''clock.Procedure_SpyProcedureLog] should exists.'';
    END
    ');
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure @P1 int AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    EXEC ('EXEC dbo.TestProcedure @P1 = 1;');

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_DefaultValue
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure @P1 int = 1 AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    EXEC ('EXEC dbo.TestProcedure;');

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 IS NULL)
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_Output
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure @P1 int OUTPUT AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    DECLARE @P1 int = 1;
    EXEC sys.sp_executesql N'EXEC dbo.TestProcedure @P1 = @P1 OUTPUT;', N'@P1 int OUTPUT', @P1 OUTPUT;

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_CommandToExecute
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure @P1 int OUTPUT AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure', 'SET @P1 = 2;';

    DECLARE @P1 int = 1;
    EXEC sys.sp_executesql N'EXEC dbo.TestProcedure @P1 = @P1 OUTPUT;', N'@P1 int OUTPUT', @P1 OUTPUT;

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');

    EXEC tSQLt.AssertEquals 2, @P1, '@P1 should equals 2.';
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_CommandToExecuteInlineComment
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure @P1 int OUTPUT AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure', 'SET @P1 = 2; --inline comment';

    DECLARE @P1 int = 1;
    EXEC sys.sp_executesql N'EXEC dbo.TestProcedure @P1 = @P1 OUTPUT;', N'@P1 int OUTPUT', @P1 OUTPUT;

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');

    EXEC tSQLt.AssertEquals 2, @P1, '@P1 should equals 2.';
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_CallOriginal
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure @P1 int OUTPUT AS BEGIN SET @P1 = 3; RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure', 'SET @P1 = 2;', @CallOriginal = 1;

    DECLARE @P1 int = 1;
    EXEC sys.sp_executesql N'EXEC dbo.TestProcedure @P1 = @P1 OUTPUT;', N'@P1 int OUTPUT', @P1 OUTPUT;

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');

    EXEC tSQLt.AssertEquals 3, @P1, '@P1 should equals 3.';
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_TableType
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure @P1 int OUTPUT, @P2 dbo.TestType READONLY AS BEGIN SET @P1 = 4 * (SELECT SUM(Column1) FROM @P2); RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure', 'SET @P1 = 3;', @CallOriginal = 1;

    DECLARE @P1 int = 1;
    DECLARE @P2 dbo.TestType;
    INSERT INTO @P2 (Column1) VALUES (2);
    EXEC sys.sp_executesql N'EXEC dbo.TestProcedure @P1 OUTPUT, @P2;', N'@P1 int OUTPUT, @P2 dbo.TestType READONLY', @P1 OUTPUT, @P2;

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1 AND CONVERT(NVARCHAR(MAX), P2) = ''<P2><row><Column1>2</Column1></row></P2>'')
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');

    EXEC tSQLt.AssertEquals 8, @P1, '@P1 should equals 8.';
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_SpyProcedureLogExists
AS
BEGIN
    CREATE TABLE dbo.TestProcedure_SpyProcedureLog (Column1 int);

    EXEC ('CREATE PROCEDURE dbo.TestProcedure AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    EXEC ('EXEC dbo.TestProcedure;');

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1)
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_SysNameIsNull
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure @P1 sysname AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    EXEC ('EXEC dbo.TestProcedure @P1 = NULL;');

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND P1 IS NULL)
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureWithP1_TableTypeNotNull
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure @P1 dbo.TestTypeNotNull READONLY AS BEGIN RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';

    DECLARE @P1 dbo.TestTypeNotNull;
    INSERT INTO @P1 (Column1) VALUES (NULL);
    EXEC sys.sp_executesql N'EXEC dbo.TestProcedure @P1;', N'@P1 dbo.TestTypeNotNull READONLY', @P1;

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND CONVERT(NVARCHAR(MAX), P1) = ''<P1><row/></P1>'')
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should exists.'';
    END
    ');
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ExternalProcedure
AS
BEGIN
    EXEC('USE master; EXEC(''CREATE SCHEMA Schema1;'')');
    EXEC('USE master; EXEC(''CREATE PROCEDURE Schema1.Procedure1 @P1 int AS BEGIN RETURN; END;'')');

    EXEC tSQLt.SpyProcedure 'master.Schema1.Procedure1';

    EXEC('USE master; EXEC Schema1.Procedure1 @P1 = 1;');

    EXEC('USE master;
    IF NOT EXISTS (SELECT 1 FROM Schema1.Procedure1_SpyProcedureLog WHERE _id_ = 1 AND P1 = 1)
    BEGIN
        RAISERROR(''%s'', 16, 10, ''Schema1.Procedure1_SpyProcedureLog should exists.'');
    END');
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_Procedure_Start_End_
AS
BEGIN
    EXEC ('CREATE PROCEDURE dbo.TestProcedure AS BEGIN WAITFOR DELAY ''00:00:00.016''; RETURN; END;');

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure', @CallOriginal = 1, @CatchExecutionTimes = 1;

    EXEC ('EXEC dbo.TestProcedure;');

    EXEC ('
    IF NOT EXISTS (SELECT 1 FROM dbo.TestProcedure_SpyProcedureLog WHERE _id_ = 1 AND DATEDIFF(ms, _start_, _end_) > 0)
    BEGIN
        EXEC tSQLt.Fail ''dbo.TestProcedure_SpyProcedureLog should has _start_ and _end_.'';
    END
    ');
END;
GO

CREATE PROCEDURE Test_SpyProcedure.Test_ProcedureDoesNotExist
AS
BEGIN
    EXEC tSQLt.ExpectException 'Cannot use SpyProcedure on dbo.TestProcedure because the procedure does not exist.';

    EXEC tSQLt.SpyProcedure 'dbo.TestProcedure';
END;
GO