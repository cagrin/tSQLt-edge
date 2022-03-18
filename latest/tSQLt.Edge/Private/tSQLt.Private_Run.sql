CREATE PROCEDURE tSQLt.Private_Run
    @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @TranCounter INT;
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    DECLARE @ExpectedMessage NVARCHAR(MAX);
    CREATE TABLE #ExpectException (ExpectedMessage NVARCHAR(MAX));

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

    IF EXISTS (SELECT 1 FROM #ExpectException)
    BEGIN
        SELECT @ExpectedMessage = ExpectedMessage FROM #ExpectException;

        IF @ErrorMessage IS NOT NULL
            EXEC tSQLt.AssertEqualsString @ExpectedMessage, @ErrorMessage;
        ELSE
            EXEC tSQLt.Fail 'Expected an exception to be raised. ExpectedMessage:', @ExpectedMessage;

        SET @ErrorMessage = NULL;
    END

    IF @TranCounter = 0
        ROLLBACK TRANSACTION;
    ELSE
        IF XACT_STATE() <> -1
            ROLLBACK TRANSACTION TestName;

    IF @ErrorMessage IS NOT NULL
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END;
GO