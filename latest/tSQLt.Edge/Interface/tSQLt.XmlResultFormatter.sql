CREATE PROCEDURE tSQLt.XmlResultFormatter
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_XmlResultFormatter';
    EXEC @Command;
END;
GO