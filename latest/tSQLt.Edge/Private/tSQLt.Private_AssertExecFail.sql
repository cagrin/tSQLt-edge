CREATE PROCEDURE tSQLt.Private_AssertExecFail
    @CommandToExecute NVARCHAR(MAX),
    @ExpectedMessage NVARCHAR(MAX)
AS BEGIN
    BEGIN TRY
        EXEC (@CommandToExecute);
    END TRY
    BEGIN CATCH
        DECLARE @ActualMessage NVARCHAR(MAX) = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @ExpectedMessage, @ActualMessage;
        RETURN;
    END CATCH
    EXEC tSQLt.Fail 'tSQLt.Private_AssertExecFail should failed.'
END;
GO