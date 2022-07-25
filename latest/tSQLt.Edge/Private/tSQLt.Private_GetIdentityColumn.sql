CREATE PROCEDURE tSQLt.Private_GetIdentityColumn
    @IdentityColumn NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX),
    @ColumnId INT
AS
BEGIN
    SELECT @IdentityColumn = CONCAT
    (
        'IDENTITY(',
        CONVERT(NVARCHAR(MAX), seed_value),
        ',',
        CONVERT(NVARCHAR(MAX), increment_value),
        ')'
    )
    FROM tSQLt.System_IdentityColumns(@ObjectName, @ColumnId)
END;
GO