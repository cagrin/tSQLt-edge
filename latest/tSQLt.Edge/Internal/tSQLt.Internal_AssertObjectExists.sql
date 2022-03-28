CREATE PROCEDURE tSQLt.Internal_AssertObjectExists
    @ObjectName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF (OBJECT_ID(@ObjectName) IS NOT NULL) OR (OBJECT_ID(CONCAT('tempdb..', @ObjectName)) IS NOT NULL)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.AssertObjectExists failed.',
            CONCAT('Object:<', ISNULL(@ObjectName, '(null)'), '>'),
            'does not exist.'
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO