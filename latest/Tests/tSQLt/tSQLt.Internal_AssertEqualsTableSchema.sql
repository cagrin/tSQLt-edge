CREATE PROCEDURE tSQLt.Internal_AssertEqualsTableSchema
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = NULL
AS
BEGIN
    PRINT '- tSQLt.AssertEqualsTableSchema';
END;
GO