CREATE SCHEMA Test_AssertStringIn;
GO

CREATE PROCEDURE Test_AssertStringIn.Test_IsUnsupported
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertStringIn is not yet supported.'

    DECLARE @Expected tSQLt.AssertStringTable;
    DECLARE @Actual NVARCHAR(MAX);
    EXEC tSQLt.AssertStringIn @Expected, @Actual;
END;
GO