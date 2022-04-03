CREATE PROCEDURE tSQLt.Internal_RemoveObjectIfExists
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    EXEC tSQLt.RemoveObject @ObjectName, @NewName OUTPUT, @IfExists = 1;
END;
GO