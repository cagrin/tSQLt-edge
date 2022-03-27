CREATE PROCEDURE tSQLt.Internal_RemoveObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT,
    @IfExists INT = 0
AS
BEGIN
    DECLARE @ObjectId INT = OBJECT_ID(@ObjectName);
    EXEC tSQLt.Private_RenameObject @ObjectId;
END;
GO