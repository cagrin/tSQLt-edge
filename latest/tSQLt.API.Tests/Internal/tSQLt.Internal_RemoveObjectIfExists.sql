CREATE PROCEDURE tSQLt.Internal_RemoveObjectIfExists
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.RemoveObjectIfExists', @ObjectName, @NewName);
END;
GO