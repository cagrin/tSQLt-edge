CREATE PROCEDURE tSQLt.Internal_RemoveObject
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT,
    @IfExists INT = 0
AS
BEGIN
    IF (OBJECT_ID(@ObjectName) IS NOT NULL) OR (OBJECT_ID(CONCAT('tempdb..', @ObjectName)) IS NOT NULL)
    BEGIN
        EXEC tSQLt.Private_RenameObject @ObjectName, @NewName OUTPUT;
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