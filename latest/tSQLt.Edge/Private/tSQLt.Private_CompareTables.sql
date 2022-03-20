CREATE PROCEDURE tSQLt.Private_CompareTables
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Diffs INT OUTPUT
AS
BEGIN
    DECLARE @ExpectedSelect NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'SELECT * FROM',
        @Expected
    );

    DECLARE @ActualSelect NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'SELECT * FROM',
        @Actual
    );

    DECLARE @DiffsCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'SELECT @Diffs = COUNT(*) FROM',
        '(',
            '(', @ExpectedSelect, 'EXCEPT', @ActualSelect, ')',
            'UNION ALL',
            '(', @ActualSelect, 'EXCEPT', @ExpectedSelect, ')',
        ') A'
    );

    EXEC sp_executesql @DiffsCommand, N'@Diffs INT OUTPUT', @Diffs OUTPUT
END;
GO