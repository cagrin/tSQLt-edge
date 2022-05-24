CREATE PROCEDURE tSQLt.Run
    @TestName NVARCHAR(MAX) = NULL,
    @TestResultFormatter NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_Run';
    EXEC @Command
    @TestName = @TestName,
    @TestResultFormatter = @TestResultFormatter;
END;
GO