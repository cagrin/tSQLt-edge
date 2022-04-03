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