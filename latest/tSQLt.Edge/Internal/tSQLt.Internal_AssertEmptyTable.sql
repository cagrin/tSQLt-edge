CREATE PROCEDURE tSQLt.Internal_AssertEmptyTable
    @TableName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.AssertEmptyTable', @TableName, @Message);
END;
GO