CREATE PROCEDURE tSQLt.Private_ProcessRunException
    @ErrorMessage NVARCHAR(4000) OUTPUT,
    @ErrorSeverity INT OUTPUT,
    @ErrorState INT OUTPUT
AS
BEGIN
    DECLARE @ExpectException BIT;
    DECLARE @ExpectedMessage NVARCHAR(MAX);
    DECLARE @ExpectedSeverity INT;
    DECLARE @ExpectedState INT;
    DECLARE @Message NVARCHAR(MAX);

    SELECT
        @ExpectException  = ExpectException,
        @ExpectedMessage  = ExpectedMessage,
        @ExpectedSeverity = ExpectedSeverity,
        @ExpectedState    = ExpectedState,
        @Message          = Message
    FROM #ExpectException

    IF @ExpectException = 0
    BEGIN
        IF @ErrorMessage IS NOT NULL
        BEGIN
            SET @ErrorMessage = CONCAT_WS
            (
                ' ',
                @Message,
                'Expected no exception to be raised.',
                CONCAT('ErrorMessage:<', @ErrorMessage, '>.')
            );
        END
    END

    IF @ExpectException = 1
    BEGIN
        IF @ErrorMessage IS NOT NULL
        BEGIN
            IF @ExpectedMessage IS NOT NULL AND NOT (@ExpectedMessage = @ErrorMessage)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ',
                    @Message,
                    'Expected an exception to be raised.',
                    CONCAT('ExpectedMessage:<', ISNULL(@ExpectedMessage, '(null)'), '>.'),
                    CONCAT('ActualMessage:<', ISNULL(@ErrorMessage, '(null)'), '>.')
                );
            END
            ELSE
                SET @ErrorMessage = NULL;

            IF @ExpectedSeverity IS NOT NULL AND NOT (@ExpectedSeverity = @ErrorSeverity)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ',
                    @Message,
                    'Expected an exception to be raised.',
                    CONCAT('ExpectedSeverity:<', ISNULL(CONVERT(NVARCHAR(MAX), @ExpectedSeverity), '(null)'), '>.'),
                    CONCAT('ActualSeverity:<', ISNULL(CONVERT(NVARCHAR(MAX), @ErrorSeverity), '(null)'), '>.')
                );
            END

            IF @ExpectedState IS NOT NULL AND NOT (@ExpectedState = @ErrorState)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ',
                    @Message,
                    'Expected an exception to be raised.',
                    CONCAT('ExpectedState:<', ISNULL(CONVERT(NVARCHAR(MAX), @ExpectedState), '(null)'), '>.'),
                    CONCAT('ActualState:<', ISNULL(CONVERT(NVARCHAR(MAX), @ErrorState), '(null)'), '>.')
                );
            END
        END
        ELSE
        BEGIN
            SET @ErrorMessage = CONCAT_WS
            (
                ' ',
                @Message,
                'Expected an exception to be raised.',
                CONCAT('ExpectedMessage:<', ISNULL(@ExpectedMessage, '(null)'), '>.')
            );
        END
    END

    DELETE FROM #ExpectException;
END;
GO