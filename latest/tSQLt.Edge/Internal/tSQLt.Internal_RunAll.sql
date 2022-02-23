CREATE PROCEDURE tSQLt.Internal_RunAll
AS
BEGIN
    EXEC tSQLt.Internal_Run @TestName = NULL;
END;
GO