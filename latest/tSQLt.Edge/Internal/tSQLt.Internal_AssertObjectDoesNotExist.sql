CREATE PROCEDURE tSQLt.Internal_AssertObjectDoesNotExist
    @ObjectName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF (OBJECT_ID(@ObjectName) IS NULL) AND (OBJECT_ID(CONCAT('tempdb..', @ObjectName)) IS NULL)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.AssertObjectDoesNotExist failed.',
            CONCAT('Object:<', ISNULL(@ObjectName, '(null)'), '>'),
            'does exist.'
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO