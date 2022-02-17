CREATE SCHEMA testAPI;
GO

CREATE PROCEDURE testAPI.[Test creation and execution]
AS
BEGIN
    EXEC tSQLt.NewTestClass 'testFinancialApp';
    EXEC tSQLt.DropClass 'testFinancialApp';
    EXEC tSQLt.RunAll;
    EXEC tSQLt.Run;
    EXEC tSQLt.Run 'MyTestClass';
    EXEC tSQLt.RenameClass 'testFinancialApp', 'FinancialAppTests';
END;
GO

CREATE PROCEDURE testAPI.RunAll
AS
BEGIN
    EXEC testAPI.[Test creation and execution]
END;
GO