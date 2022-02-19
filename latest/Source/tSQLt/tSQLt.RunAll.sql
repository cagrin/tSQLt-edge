CREATE PROCEDURE tSQLt.RunAll
AS
BEGIN
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_RunAll';
    EXEC @Command;
END;
GO