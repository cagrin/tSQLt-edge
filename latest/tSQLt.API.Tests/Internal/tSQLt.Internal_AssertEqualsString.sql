CREATE PROCEDURE tSQLt.Internal_AssertEqualsString
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.AssertEqualsString', @Expected, @Actual, @Message);
END;
GO