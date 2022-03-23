CREATE PROCEDURE tSQLt.Private_Run
    @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @TranCounter INT;
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    CREATE TABLE #ExpectException (ExpectException BIT NOT NULL, ExpectedMessage NVARCHAR(MAX), [Message] NVARCHAR(MAX));

    -- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/save-transaction-transact-sql?view=sql-server-ver15
    SET @TranCounter = @@TRANCOUNT;
    IF @TranCounter = 0
        BEGIN TRANSACTION;
    ELSE
        SAVE TRANSACTION TestName;

    BEGIN TRY
        PRINT @TestName;
        EXEC @TestName;
    END TRY
    BEGIN CATCH
        SELECT @ErrorMessage = ERROR_MESSAGE();
        SELECT @ErrorSeverity = ERROR_SEVERITY();
        SELECT @ErrorState = ERROR_STATE();
    END CATCH

    EXEC tSQLt.Private_ProcessRunException @ErrorMessage OUTPUT, @ErrorSeverity OUTPUT, @ErrorState OUTPUT;

    IF @TranCounter = 0
        ROLLBACK TRANSACTION;
    ELSE
        IF XACT_STATE() <> -1
            ROLLBACK TRANSACTION TestName;

    IF @ErrorMessage IS NOT NULL
        RAISERROR(N'%s', 16, 10, @ErrorMessage);
END;
GO