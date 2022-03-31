CREATE FUNCTION tSQLt.Private_GetDefaultConstraints (@ObjectName NVARCHAR(MAX), @ColumnId INT)
RETURNS NVARCHAR(MAX) AS
BEGIN
    RETURN
    (
        SELECT CONCAT('DEFAULT ', definition)
        FROM tSQLt.System_DefaultConstraints(@ObjectName, @ColumnId)
    );
END;
GO