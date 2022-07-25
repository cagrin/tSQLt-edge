CREATE PROCEDURE tSQLt.Private_GetDefaultConstraints
    @DefaultConstraints NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX),
    @ColumnId INT
AS
BEGIN
    SELECT @DefaultConstraints = CONCAT
    (
        'DEFAULT ',
        definition
    )
    FROM tSQLt.System_DefaultConstraints(@ObjectName, @ColumnId)
END;
GO