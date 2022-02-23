CREATE PROCEDURE tSQLt.Private_Run
    @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
    PRINT @TestName;
    EXEC @TestName;
END;
GO