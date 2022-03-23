CREATE PROCEDURE tSQLt.Internal_AssertEmptyTable
    @TableName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @IsEmpty BIT; EXEC tSQLt.Private_IsEmptyTable @TableName, @IsEmpty OUTPUT;

    IF (@IsEmpty = 1)
    BEGIN
        RETURN;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT
        (
            'tSQLt.AssertEmptyTable failed. Expected:<',
            @TableName,
            '> is not empty.'
        );
        EXEC tSQLt.Fail @Message, @Failed;
    END
END;
GO