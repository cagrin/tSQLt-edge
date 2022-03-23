CREATE PROCEDURE tSQLt.Private_ProcessRunException
    @ErrorMessage NVARCHAR(4000) OUTPUT,
    @ErrorSeverity INT OUTPUT,
    @ErrorState INT OUTPUT
AS
BEGIN
    DECLARE @ExpectException BIT;
    DECLARE @ExpectedMessage NVARCHAR(MAX);
    DECLARE @Message NVARCHAR(MAX);

    SELECT
        @ExpectException = ExpectException,
        @ExpectedMessage = ExpectedMessage,
        @Message         = Message
    FROM #ExpectException

    IF @ExpectException = 0
    BEGIN
        IF @ErrorMessage IS NOT NULL
        BEGIN
            SET @ErrorMessage = CONCAT
            (
                'Expected no exception to be raised. ErrorMessage:<',
                @ErrorMessage,
                '>.'
            );
        END
    END

    IF @ExpectException = 1
    BEGIN
        IF @ErrorMessage IS NOT NULL
        BEGIN
            IF @ExpectedMessage = @ErrorMessage
            BEGIN
                SET @ErrorMessage = NULL;
            END
            ELSE
            BEGIN
                SET @ErrorMessage = CONCAT
                (
                    'Expected an exception to be raised. ExpectedMessage:<',
                    ISNULL(@ExpectedMessage, '(null)'),
                    '>. ActualMessage:<',
                    ISNULL(@ErrorMessage, '(null)'),
                    '>.'
                );
            END
        END
        ELSE
        BEGIN
            SET @ErrorMessage = CONCAT
            (
                'Expected an exception to be raised. ExpectedMessage:<',
                ISNULL(@ExpectedMessage, '(null)'),
                '>.'
            );
        END
    END

    DELETE FROM #ExpectException;
END;
GO