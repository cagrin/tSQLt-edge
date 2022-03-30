CREATE FUNCTION tSQLt.Private_GetIdentityColumn (@ObjectName NVARCHAR(MAX), @ColumnId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT CONCAT('IDENTITY(', CONVERT(NVARCHAR(MAX), seed_value), ',', CONVERT(NVARCHAR(MAX), increment_value), ')')
        FROM tSQLt.System_IdentityColumns(@ObjectName, @ColumnId)
    );
END;
GO