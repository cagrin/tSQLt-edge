CREATE PROCEDURE tSQLt.Internal_FakeTableDebug
    @TableName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL, --parameter preserved for backward compatibility. Do not use. Will be removed soon.
    @Identity BIT = NULL,
    @ComputedColumns BIT = NULL,
    @Defaults BIT = NULL
AS
BEGIN
BEGIN TRY
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_FakeTable';
    EXEC @Command
    @TableName = @TableName,
    @SchemaName = @SchemaName,
    @Identity = @Identity,
    @ComputedColumns = @ComputedColumns,
    @Defaults = @Defaults;
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
    IF @ErrorMessage LIKE 'tSQLt.AssertObjectExists failed.%'
    BEGIN
        RAISERROR('FakeTable could not resolve the object name, ''%s''. (When calling tSQLt.FakeTable, avoid the use of the @SchemaName parameter, as it is deprecated.)', 16, 10, @TableName);
    END
    RAISERROR('%s', 16, 10, @ErrorMessage);
END CATCH
END;