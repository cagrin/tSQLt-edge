CREATE PROCEDURE tSQLt.Internal_AssertEqualsTableSchema
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.AssertEqualsTableSchema', @Expected, @Actual, @Message);
END;
GO