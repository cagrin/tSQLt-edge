CREATE PROCEDURE tSQLt.Internal_Run
    @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.Run', @TestName);
END;
GO