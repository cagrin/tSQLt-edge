CREATE PROC tSQLt_testutil.AssertFailMessageLike
    @Command NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX),
    @Message0 VARCHAR(MAX) = NULL,
    @Message1 VARCHAR(MAX) = NULL,
    @Message2 VARCHAR(MAX) = NULL,
    @Message3 VARCHAR(MAX) = NULL,
    @Message4 VARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Message VARCHAR(MAX) = CONCAT(COALESCE(@Message0, ''), COALESCE(@Message1, ''), COALESCE(@Message2, ''), COALESCE(@Message3, ''), COALESCE(@Message4, ''));
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = @ExpectedMessage, @Message = @Message;
    EXEC (@Command);
END;
GO

CREATE PROC tSQLt_testutil.AssertFailMessageEquals
    @Command NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX),
    @Message0 VARCHAR(MAX) = NULL,
    @Message1 VARCHAR(MAX) = NULL,
    @Message2 VARCHAR(MAX) = NULL,
    @Message3 VARCHAR(MAX) = NULL,
    @Message4 VARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Message VARCHAR(MAX) = CONCAT(COALESCE(@Message0, ''), COALESCE(@Message1, ''), COALESCE(@Message2, ''), COALESCE(@Message3, ''), COALESCE(@Message4, ''));
    EXEC tSQLt.ExpectException @ExpectedMessage = @ExpectedMessage, @Message = @Message;
    EXEC (@Command);
END;
GO

CREATE PROC tSQLt_testutil.assertFailCalled
    @Command NVARCHAR(MAX),
    @Message VARCHAR(MAX) = NULL
AS
BEGIN
    EXEC tSQLt.ExpectException @Message = @Message;
    EXEC (@Command);
END;
GO

CREATE PROCEDURE tSQLt_testutil.AssertTestSucceeds
    @TestName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @TranName CHAR(32); EXEC tSQLt.Private_GetNewTranName @TranName OUTPUT;
    EXEC tSQLt.Private_Run @TestName, @TranName, @ErrorMessage OUTPUT;

    EXEC tSQLt.AssertEqualsString NULL, @ErrorMessage;
END;
GO

CREATE PROC tSQLt_testutil.AssertTestFails
    @TestName NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @TranName CHAR(32); EXEC tSQLt.Private_GetNewTranName @TranName OUTPUT;
    EXEC tSQLt.Private_Run @TestName, @TranName, @ErrorMessage OUTPUT;

    IF @ExpectedMessage IS NULL
        EXEC tSQLt.AssertNotEqualsString NULL, @ErrorMessage;
    ELSE
    BEGIN
        DECLARE @NL NVARCHAR(MAX) = CHAR(13) + CHAR(10);

        -- [ExpectExceptionTests].[test tSQLt.ExpectException with no parms produces default fail message ]
        IF  @ErrorMessage = 'Expected an exception to be raised.'
        SET @ErrorMessage = 'Expected an error to be raised.';

        -- [ExpectExceptionTests].[test output includes additional message if no other expectations]
        IF  @ErrorMessage = 'Additional Fail Message. Expected an exception to be raised.'
        SET @ErrorMessage = 'Additional Fail Message. Expected an error to be raised.';

        -- [ExpectExceptionTests].[test output includes additional message]
        IF  @ErrorMessage = 'Additional Fail Message. Expected an exception to be raised. ExpectedMessage:<Correct>. ActualMessage:<Wrong>.'
        SET @ErrorMessage =
        'Additional Fail Message. Exception did not match expectation!'+@NL+
        'Expected Message: <Correct>'+@NL+
        'Actual Message  : <Wrong>';

        -- [ExpectExceptionTests].[test output includes every incorrect part including the MessagePattern]
        IF  @ErrorMessage = 'Expected an exception to be raised. ExpectedSeverity:<11>. ActualSeverity:<12>.'
        SET @ErrorMessage =
        'Exception did not match expectation!'+@NL+
        'Expected Message to be like <Cor[rt]ect>'+@NL+
        'Actual Message            : <Wrong>'+@NL+
        'Expected Error Number: 50001'+@NL+
        'Actual Error Number  : 50000'+@NL+
        'Expected Severity: 11'+@NL+
        'Actual Severity  : 12'+@NL+
        'Expected State: 9'+@NL+
        'Actual State  : 6';

        -- [ExpectExceptionTests].[test output includes every incorrect part]
        IF  @ErrorMessage = 'Expected an exception to be raised. ExpectedMessage:<Correct>. ActualMessage:<Wrong>.'
        SET @ErrorMessage =
        'Exception did not match expectation!'+@NL+
        'Expected Message: <Correct>'+@NL+
        'Actual Message  : <Wrong>'+@NL+
        'Expected Error Number: 50001'+@NL+
        'Actual Error Number  : 50000'+@NL+
        'Expected Severity: 11'+@NL+
        'Actual Severity  : 12'+@NL+
        'Expected State: 9'+@NL+
        'Actual State  : 6';

        -- [ExpectExceptionTests].[test raising wrong error number produces meaningful output]
        IF  @ErrorMessage = 'Expected an exception to be raised. ExpectedErrorNumber:<50001>. ActualErrorNumber:<50000>.'
        SET @ErrorMessage =
        '%Expected Error Number: 50001'+@NL+
        'Actual Error Number  : 50000';

        -- [ExpectExceptionTests].[test raising wrong severity produces meaningful output]
        IF  @ErrorMessage = 'Expected an exception to be raised. ExpectedSeverity:<13>. ActualSeverity:<14>.'
        SET @ErrorMessage =
        '%Expected Severity: 13'+@NL+
        'Actual Severity  : 14';

        -- [ExpectExceptionTests].[test raising wrong state produces meaningful output]
        IF  @ErrorMessage = 'Expected an exception to be raised. ExpectedState:<13>. ActualState:<10>.'
        SET @ErrorMessage =
        '%Expected State: 13'+@NL+
        'Actual State  : 10';

        -- [ExpectExceptionTests].[test raising wrong message produces meaningful output]
        IF  @ErrorMessage = 'Expected an exception to be raised. ExpectedMessage:<Correct Message>. ActualMessage:<Wrong Message>.'
        SET @ErrorMessage =
        '%Expected Message: <Correct Message>'+@NL+
        'Actual Message  : <Wrong Message>';

        -- [ExpectNoExceptionTests].[test tSQLt.ExpectNoException includes additional message in fail message ]
        IF  @ErrorMessage = 'Additional Fail Message. Expected no exception to be raised. ErrorMessage:<test error message>. ErrorSeverity:<16>. ErrorState:<10>. ErrorNumber:<50000>.'
        SET @ErrorMessage = 'Additional Fail Message. Expected no error to be raised. Instead %';

        EXEC tSQLt.AssertLike @ExpectedMessage, @ErrorMessage;
    END
END;
GO