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

    DECLARE @ExpectedNoExceptionMessage NVARCHAR(MAX) = 'Expected no exception to be raised.';
    DECLARE @ExpectedExceptionMessage NVARCHAR(MAX) = 'Expected an exception to be raised.';

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
                ' ', @Message, @ExpectedNoExceptionMessage,
                CONCAT('ErrorMessage:<', @ErrorMessage, '>.'),
                CONCAT('ErrorSeverity:<', CONVERT(NVARCHAR(MAX), @ErrorSeverity), '>.'),
                CONCAT('ErrorState:<', CONVERT(NVARCHAR(MAX), @ErrorState), '>.'),
                CONCAT('ErrorNumber:<', CONVERT(NVARCHAR(MAX), @ErrorNumber), '>.')
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
                    ' ', @Message, @ExpectedExceptionMessage,
                    CONCAT('ExpectedMessage:<', @ExpectedMessage, '>.'),
                    CONCAT('ActualMessage:<', ISNULL(@ErrorMessage, '(null)'), '>.')
                );
            END
            ELSE IF @ExpectedSeverity IS NOT NULL AND NOT (@ExpectedSeverity = @ErrorSeverity)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ', @Message, @ExpectedExceptionMessage,
                    CONCAT('ExpectedSeverity:<', CONVERT(NVARCHAR(MAX), @ExpectedSeverity), '>.'),
                    CONCAT('ActualSeverity:<', CONVERT(NVARCHAR(MAX), @ErrorSeverity), '>.')
                );
            END
            ELSE IF @ExpectedState IS NOT NULL AND NOT (@ExpectedState = @ErrorState)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ', @Message, @ExpectedExceptionMessage,
                    CONCAT('ExpectedState:<', CONVERT(NVARCHAR(MAX), @ExpectedState), '>.'),
                    CONCAT('ActualState:<', CONVERT(NVARCHAR(MAX), @ErrorState), '>.')
                );
            END
            ELSE IF @ExpectedMessagePattern IS NOT NULL AND NOT (@ErrorMessage LIKE @ExpectedMessagePattern)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ', @Message, @ExpectedExceptionMessage,
                    CONCAT('ExpectedMessagePattern:<', @ExpectedMessagePattern, '>.'),
                    CONCAT('ActualMessage:<', ISNULL(@ErrorMessage, '(null)'), '>.')
                );
            END
            ELSE IF @ExpectedErrorNumber IS NOT NULL AND NOT (@ExpectedErrorNumber = @ErrorNumber)
            BEGIN
                SET @ErrorMessage = CONCAT_WS
                (
                    ' ', @Message, @ExpectedExceptionMessage,
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
                ' ', @Message, @ExpectedExceptionMessage,
                CASE WHEN @ExpectedMessage IS NOT NULL THEN CONCAT('ExpectedMessage:<', @ExpectedMessage, '>.') ELSE NULL END,
                CASE WHEN @ExpectedSeverity IS NOT NULL THEN CONCAT('ExpectedSeverity:<', CONVERT(NVARCHAR(MAX), @ExpectedSeverity), '>.') ELSE NULL END,
                CASE WHEN @ExpectedState IS NOT NULL THEN CONCAT('ExpectedState:<', CONVERT(NVARCHAR(MAX), @ExpectedState), '>.') ELSE NULL END,
                CASE WHEN @ExpectedMessagePattern IS NOT NULL THEN CONCAT('ExpectedMessagePattern:<', @ExpectedMessagePattern, '>.') ELSE NULL END,
                CASE WHEN @ExpectedErrorNumber IS NOT NULL THEN CONCAT('ExpectedErrorNumber:<', CONVERT(NVARCHAR(MAX), @ExpectedErrorNumber), '>.') ELSE NULL END
            );
        END
    END
END;
GO