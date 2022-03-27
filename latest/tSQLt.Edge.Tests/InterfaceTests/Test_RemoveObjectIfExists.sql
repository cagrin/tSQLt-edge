CREATE SCHEMA Test_RemoveObjectIfExists;
GO

CREATE PROCEDURE Test_RemoveObjectIfExists.Test_Table
AS
BEGIN
    EXEC tSQLt.RemoveObjectIfExists 'dbo.NewTable';
END;
GO

CREATE PROCEDURE Test_RemoveObjectIfExists.Test_Null
AS
BEGIN
    EXEC tSQLt.RemoveObjectIfExists NULL;
END;
GO