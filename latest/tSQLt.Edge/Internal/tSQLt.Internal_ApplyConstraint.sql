CREATE PROCEDURE tSQLt.Internal_ApplyConstraint
    @TableName NVARCHAR(MAX),
    @ConstraintName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL, --parameter preserved for backward compatibility. Do not use. Will be removed soon.
    @NoCascade BIT = 0
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.ApplyConstraint', @TableName, @ConstraintName, @SchemaName, '@NoCascade');
END;
GO