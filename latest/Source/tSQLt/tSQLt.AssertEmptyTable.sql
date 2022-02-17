CREATE PROCEDURE tSQLt.AssertEmptyTable
    @TableName NVARCHAR(MAX),
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    PRINT '- tSQLt.AssertEmptyTable';
END;
GO