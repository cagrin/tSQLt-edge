CREATE PROCEDURE tSQLt.Internal_AssertEmptyTable
    @TableName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    EXEC tSQLt.AssertObjectExists @TableName;

    DECLARE @IsEmpty BIT; EXEC tSQLt.Private_IsEmptyTable @TableName, @IsEmpty OUTPUT;

    IF (@IsEmpty = 1)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.AssertEmptyTable failed.',
            CONCAT('Expected:<', @TableName, '> is not empty.')
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO