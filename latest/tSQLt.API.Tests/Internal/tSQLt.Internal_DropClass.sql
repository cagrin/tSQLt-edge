CREATE PROCEDURE tSQLt.Internal_DropClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
    PRINT CONCAT_WS(' ', '- tSQLt.DropClass', @ClassName);
END;
GO