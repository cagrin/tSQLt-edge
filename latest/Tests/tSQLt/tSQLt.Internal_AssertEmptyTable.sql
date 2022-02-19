CREATE PROCEDURE tSQLt.Internal_AssertEmptyTable
    @TableName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT '- tSQLt.AssertEmptyTable';
END;
GO