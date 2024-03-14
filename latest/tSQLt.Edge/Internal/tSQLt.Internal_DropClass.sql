CREATE PROCEDURE tSQLt.Internal_DropClass
    @ClassName NVARCHAR(MAX)
AS
BEGIN
    EXEC tSQLt.Fail 'tSQLt.DropClass of', @ClassName, 'is not supported.';
END;
GO