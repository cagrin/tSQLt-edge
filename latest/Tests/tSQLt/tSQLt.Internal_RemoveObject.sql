CREATE PROCEDURE tSQLt.Internal_RemoveObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT,
    @IfExists INT = 0
AS
BEGIN
    PRINT '- tSQLt.RemoveObject';
END;
GO