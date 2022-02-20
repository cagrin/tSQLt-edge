CREATE PROCEDURE tSQLt.Internal_RemoveObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT,
    @IfExists INT = 0
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.RemoveObject', @ObjectName, @NewName, '@IfExists');
END;
GO