CREATE PROCEDURE tSQLt.ApplyConstraint
    @TableName NVARCHAR(MAX),
    @ConstraintName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL, --parameter preserved for backward compatibility. Do not use. Will be removed soon.
    @NoCascade BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_ApplyConstraint';
    EXEC @Command
    @TableName = @TableName,
    @ConstraintName = @ConstraintName,
    @SchemaName = @SchemaName,
    @NoCascade = @NoCascade;
END;
GO