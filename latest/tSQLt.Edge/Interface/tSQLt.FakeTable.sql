CREATE PROCEDURE tSQLt.FakeTable
    @TableName NVARCHAR(MAX),
    @Identity BIT = NULL,
    @ComputedColumns BIT = NULL,
    @Defaults BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_FakeTable';
    EXEC @Command
    @TableName = @TableName,
    @Identity = @Identity,
    @ComputedColumns = @ComputedColumns,
    @Defaults = @Defaults;
END;
GO