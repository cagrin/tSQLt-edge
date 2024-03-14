CREATE SCHEMA Test_Run;
GO

CREATE PROCEDURE Test_Run.Test_CreateNewTable
AS
BEGIN
    CREATE TABLE dbo.NewTable (Id INT);

    IF OBJECT_ID ('dbo.NewTable', 'U') IS NULL
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewTable should exists.';
    END
END;
GO

CREATE PROCEDURE Test_Run.Test_NestedTransactions
AS
BEGIN
    EXEC tSQLt.Run '[Test_Run].[Test_CreateNewTable]';

    IF OBJECT_ID ('dbo.NewTable', 'U') IS NOT NULL
    BEGIN
        EXEC tSQLt.Fail 'dbo.NewTable should not exists.';
    END
END;
GO

CREATE PROCEDURE Test_Run.Test_ResultFormatter_IsUnsupported
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.Run with @TestResultFormatter is not supported.'

    EXEC tSQLt.Run '[Test_Run].[Test_CreateNewTable]', @TestResultFormatter = 'ResultFormatter';
END;
GO