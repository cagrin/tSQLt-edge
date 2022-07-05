CREATE PROCEDURE tSQLt.TableToText
    @txt NVARCHAR(MAX) OUTPUT,
    @TableName NVARCHAR(MAX),
    @OrderBy NVARCHAR(MAX) = NULL,
    @PrintOnlyColumnNameAliasList NVARCHAR(MAX) = NULL
AS
BEGIN
    SET @txt = '';
END;
GO

CREATE PROCEDURE tSQLt.Private_PrepareFakeFunctionOutputTable
    @FakeDataSource NVARCHAR(MAX),
    @OutputTable NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET @OutputTable = '';
END;
GO

CREATE PROCEDURE tSQLt.CaptureOutput
    @command NVARCHAR(MAX)
AS
BEGIN
    RETURN;
END;
GO

CREATE PROCEDURE tSQLt.Private_GenerateCreateProcedureSpyStatement
    @ProcedureObjectId INT,
    @OriginalProcedureName NVARCHAR(MAX),
    @UnquotedNewNameOfProcedure NVARCHAR(MAX) = NULL,
    @LogTableName NVARCHAR(MAX),
    @CommandToExecute NVARCHAR(MAX),
    @CallOriginal BIT,
    @CreateProcedureStatement NVARCHAR(MAX) OUTPUT,
    @CreateLogTableStatement NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET @CreateProcedureStatement = '';
    SET @CreateLogTableStatement = '';
END;
GO

CREATE FUNCTION tSQLt.Private_SqlVariantFormatter(@Value SQL_VARIANT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN '';
END;
GO

CREATE FUNCTION tSQLt.F_Num(@N INT)
RETURNS TABLE
AS
RETURN
(
    WITH
        C0(c) AS (SELECT 1 UNION ALL SELECT 1),
        C1(c) AS (SELECT 1 FROM C0 AS A CROSS JOIN C0 AS B),
        C2(c) AS (SELECT 1 FROM C1 AS A CROSS JOIN C1 AS B),
        C3(c) AS (SELECT 1 FROM C2 AS A CROSS JOIN C2 AS B),
        C4(c) AS (SELECT 1 FROM C3 AS A CROSS JOIN C3 AS B),
        C5(c) AS (SELECT 1 FROM C4 AS A CROSS JOIN C4 AS B),
        C6(c) AS (SELECT 1 FROM C5 AS A CROSS JOIN C5 AS B)
    SELECT TOP(CASE WHEN @N>0 THEN @N ELSE 0 END) ROW_NUMBER() OVER (ORDER BY c) no
    FROM C6
);
GO