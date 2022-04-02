CREATE PROCEDURE tSQLt.Private_CompareTables
    @Expected NVARCHAR(MAX),
    @Actual NVARCHAR(MAX),
    @Diffs INT OUTPUT
AS
BEGIN
    DECLARE @ColumnsNames NVARCHAR(MAX) = tSQLt.Private_GetColumnsNames(@Expected);

    DECLARE @DiffsCommand NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'SELECT _row_ = ROW_NUMBER() OVER(ORDER BY', @ColumnsNames, '), * INTO #Expecte_d FROM', @Expected,
        'SELECT _row_ = ROW_NUMBER() OVER(ORDER BY', @ColumnsNames, '), * INTO #Actua___l FROM', @Actual,
        'SELECT @Diffs = COUNT(1) FROM',
        '(',
            '(',
                'SELECT * FROM #Expecte_d',
                'EXCEPT',
                'SELECT * FROM #Actua___l',
            ')',
            'UNION ALL',
            '(',
                'SELECT * FROM #Actua___l',
                'EXCEPT',
                'SELECT * FROM #Expecte_d',
            ')',
        ') A'
    );

    EXEC sys.sp_executesql @DiffsCommand, N'@Diffs INT OUTPUT', @Diffs OUTPUT
END;
GO