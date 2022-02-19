CREATE PROCEDURE tSQLt.Internal_RemoveObjectIfExists
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    PRINT '- tSQLt.RemoveObjectIfExists';
END;
GO