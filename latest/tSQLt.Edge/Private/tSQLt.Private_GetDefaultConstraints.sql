CREATE PROCEDURE tSQLt.Private_GetDefaultConstraints
    @DefaultConstraints NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX),
    @ColumnId INT
AS
BEGIN
    DECLARE @System_DefaultConstraints tSQLt.System_DefaultConstraintsType
    INSERT INTO @System_DefaultConstraints
    EXEC tSQLt.System_DefaultConstraints @ObjectName, @ColumnId

    SELECT @DefaultConstraints = CONCAT
    (
        'DEFAULT ',
        definition
    )
    FROM @System_DefaultConstraints
END;
GO