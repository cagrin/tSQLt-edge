CREATE PROCEDURE tSQLt.Private_Run
    @TestName NVARCHAR(MAX),
    @TranName CHAR(32),
    @ErrorMessage NVARCHAR(MAX) OUTPUT
AS
BEGIN
    DECLARE @TranCounter INT;
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    DECLARE @ErrorNumber INT;

    -- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/save-transaction-transact-sql?view=sql-server-ver15
    SET @TranCounter = @@TRANCOUNT;
    IF @TranCounter = 0
        BEGIN TRANSACTION;
    ELSE
        SAVE TRANSACTION @TranName;

    BEGIN TRY
        EXEC tSQLt.Private_RunTestSetUp @TestName;

        EXEC @TestName;
        SET @ErrorMessage = NULL;
    END TRY
    BEGIN CATCH
        SELECT @ErrorMessage = ERROR_MESSAGE();
        SELECT @ErrorSeverity = ERROR_SEVERITY();
        SELECT @ErrorState = ERROR_STATE();
        SELECT @ErrorNumber = ERROR_NUMBER();
    END CATCH

    EXEC tSQLt.Private_ProcessErrorMessage @ErrorMessage OUTPUT, @ErrorSeverity, @ErrorState, @ErrorNumber;

    IF @TranCounter = 0
        ROLLBACK TRANSACTION;
    ELSE
        IF XACT_STATE() <> -1
            ROLLBACK TRANSACTION @TranName;
END;
GO