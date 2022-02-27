CREATE SCHEMA Test_Run;
GO

CREATE PROCEDURE Test_Run.Test_CreateNewTable
AS
BEGIN
    BEGIN TRY
        CREATE TABLE dbo.NewTable (Id INT);

        IF OBJECT_ID ('dbo.NewTable', 'U') IS NULL
        BEGIN
            EXEC tSQLt.Fail 'dbo.NewTable should exists.';
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();

        EXEC tSQLt.Fail @ErrorMessage;
    END CATCH
END;
GO

CREATE PROCEDURE Test_Run.Test_NestedTransactions
AS
BEGIN
    BEGIN TRY
        EXEC tSQLt.Run '[Test_Run].[Test_CreateNewTable]';

        IF OBJECT_ID ('dbo.NewTable', 'U') IS NOT NULL
        BEGIN
            EXEC tSQLt.Fail 'dbo.NewTable should not exists.';
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();

        EXEC tSQLt.Fail @ErrorMessage;
    END CATCH
END;
GO