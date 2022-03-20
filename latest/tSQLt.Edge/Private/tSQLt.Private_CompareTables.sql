CREATE PROCEDURE tSQLt.Private_CompareTables
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Diffs INT OUTPUT
AS
BEGIN
    DECLARE @ColumnsNames NVARCHAR(MAX) = tSQLt.Private_GetColumnsNames(OBJECT_ID(@Expected));

    DECLARE @DiffsCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'SELECT _row_ = ROW_NUMBER() OVER(ORDER BY', @ColumnsNames, '), * INTO #Expected FROM', @Expected,
        'SELECT _row_ = ROW_NUMBER() OVER(ORDER BY', @ColumnsNames, '), * INTO #Actual FROM', @Actual,
        'SELECT @Diffs = COUNT(1) FROM',
        '(',
            '(',
                'SELECT * FROM #Expected',
                'EXCEPT',
                'SELECT * FROM #Actual',
            ')',
            'UNION ALL',
            '(',
                'SELECT * FROM #Actual',
                'EXCEPT',
                'SELECT * FROM #Expected',
            ')',
        ') A'
    );

    EXEC sys.sp_executesql @DiffsCommand, N'@Diffs INT OUTPUT', @Diffs OUTPUT
END;
GO