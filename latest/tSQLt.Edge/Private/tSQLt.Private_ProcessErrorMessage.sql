CREATE PROCEDURE tSQLt.Private_ProcessErrorMessage
    @ErrorMessage NVARCHAR(4000) OUTPUT,
    @ErrorSeverity INT,
    @ErrorState INT,
    @ErrorNumber INT
AS
BEGIN
    DECLARE @ExpectException BIT;
    DECLARE @ExpectedMessage NVARCHAR(MAX);
    DECLARE @ExpectedSeverity INT;
    DECLARE @ExpectedState INT;
    DECLARE @Message NVARCHAR(MAX);
    DECLARE @ExpectedMessagePattern NVARCHAR(MAX);
    DECLARE @ExpectedErrorNumber INT;

    SELECT
        @ExpectException  = ExpectException,
        @ExpectedMessage  = ExpectedMessage,
        @ExpectedSeverity = ExpectedSeverity,
        @ExpectedState    = ExpectedState,
        @Message          = Message,
        @ExpectedMessagePattern = ExpectedMessagePattern,
        @ExpectedErrorNumber    = ExpectedErrorNumber
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
                    CONCAT('ExpectedMessage:<', @ExpectedMessage, '>.'),
                    CONCAT('ActualMessage:<', ISNULL(@ErrorMessage, '(null)'), '>.')
                );
            END
            ELSE IF @ExpectedSeverity IS NOT NULL AND NOT (@ExpectedSeverity = @ErrorSeverity)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ',
                    @Message,
                    'Expected an exception to be raised.',
                    CONCAT('ExpectedSeverity:<', CONVERT(NVARCHAR(MAX), @ExpectedSeverity), '>.'),
                    CONCAT('ActualSeverity:<', CONVERT(NVARCHAR(MAX), @ErrorSeverity), '>.')
                );
            END
            ELSE IF @ExpectedState IS NOT NULL AND NOT (@ExpectedState = @ErrorState)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ',
                    @Message,
                    'Expected an exception to be raised.',
                    CONCAT('ExpectedState:<', CONVERT(NVARCHAR(MAX), @ExpectedState), '>.'),
                    CONCAT('ActualState:<', CONVERT(NVARCHAR(MAX), @ErrorState), '>.')
                );
            END
            ELSE IF @ExpectedMessagePattern IS NOT NULL AND NOT (@ErrorMessage LIKE @ExpectedMessagePattern)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ',
                    @Message,
                    'Expected an exception to be raised.',
                    CONCAT('ExpectedMessagePattern:<', @ExpectedMessagePattern, '>.'),
                    CONCAT('ActualMessage:<', ISNULL(@ErrorMessage, '(null)'), '>.')
                );
            END
            ELSE IF @ExpectedErrorNumber IS NOT NULL AND NOT (@ExpectedErrorNumber = @ErrorNumber)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ',
                    @Message,
                    'Expected an exception to be raised.',
                    CONCAT('ExpectedErrorNumber:<', CONVERT(NVARCHAR(MAX), @ExpectedErrorNumber), '>.'),
                    CONCAT('ActualErrorNumber:<', CONVERT(NVARCHAR(MAX), @ErrorNumber), '>.')
                );
            END
            ELSE
                SET @ErrorMessage = NULL;
        END
        ELSE
        BEGIN
            SET @ErrorMessage = CONCAT_WS
            (
                ' ',
                @Message,
                'Expected an exception to be raised.'
            );
        END
    END

    DELETE FROM #ExpectException;
END;
GO