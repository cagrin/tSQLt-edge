CREATE PROCEDURE tSQLt.Run
    @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_Run';
    EXEC @Command
    @TestName = @TestName;
END;
GO