CREATE PROCEDURE tSQLt.Internal_RemoveObjectDebug
    @ObjectName NVARCHAR(MAX),
    @NewName NVARCHAR(MAX) = NULL OUTPUT,
    @IfExists INT = 0
AS
BEGIN
BEGIN TRY
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_RemoveObject';
    EXEC @Command
    @ObjectName = @ObjectName,
    @NewName = @NewName OUTPUT,
    @IfExists = @IfExists;
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
    IF @ErrorMessage LIKE '%does not exist%'
    BEGIN
        RAISERROR('%s does not exist!', 16, 10, @ObjectName);
    END
    RAISERROR('%s', 16, 10, @ErrorMessage);
END CATCH
END;
GO