CREATE PROCEDURE tSQLt.Internal_RemoveObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT,
    @IfExists INT = 0
AS
BEGIN
    DECLARE @ObjectId INT = OBJECT_ID(@ObjectName);

    IF (@ObjectId IS NOT NULL)
    BEGIN
        EXEC tSQLt.Private_RenameObject @ObjectId, @NewName OUTPUT;
    END
    ELSE
    BEGIN
        IF @IfExists = 0
        BEGIN
            DECLARE @Failed NVARCHAR(MAX) = CONCAT
            (
                'tSQLt.RemoveObject failed. ObjectName:<',
                ISNULL(CONVERT(NVARCHAR(MAX), @ObjectName), '(null)'),
                '> does not exist.'
            );
            EXEC tSQLt.Fail @Failed;
        END
    END;
END;
GO