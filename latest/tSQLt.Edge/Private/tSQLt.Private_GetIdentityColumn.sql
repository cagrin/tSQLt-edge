CREATE PROCEDURE tSQLt.Private_GetIdentityColumn
    @IdentityColumn NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX),
    @ColumnId INT
AS
BEGIN
    DECLARE @IdentityColumns tSQLt.System_IdentityColumnsType
    INSERT INTO @IdentityColumns
    EXEC tSQLt.System_IdentityColumns @ObjectName, @ColumnId

    SELECT @IdentityColumn = CONCAT
    (
        'IDENTITY(',
        CONVERT(NVARCHAR(MAX), seed_value),
        ',',
        CONVERT(NVARCHAR(MAX), increment_value),
        ')'
    )
    FROM @IdentityColumns
END;
GO