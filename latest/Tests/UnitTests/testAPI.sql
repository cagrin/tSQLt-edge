CREATE SCHEMA testAPI;
GO

CREATE PROCEDURE testAPI.[Test creation and execution]
AS
BEGIN
    PRINT 'Test creation and execution:';
    EXEC tSQLt.NewTestClass 'testFinancialApp';
    EXEC tSQLt.DropClass 'testFinancialApp';
    EXEC tSQLt.RunAll;
    EXEC tSQLt.Run 'testFinancialApp';
    EXEC tSQLt.RenameClass 'testFinancialApp', 'testFiscalApp';
END;
GO

CREATE PROCEDURE testAPI.[Assertions]
AS
BEGIN
    PRINT 'Assertions:';
    EXEC tSQLt.AssertEmptyTable 'actual';
    EXEC tSQLt.AssertEquals 3.0, 3.0;
    EXEC tSQLt.AssertEqualsString 'hello', 'hello';
    EXEC tSQLt.AssertEqualsTable 'expected', 'actual';
    EXEC tSQLt.AssertEqualsTableSchema 'expected', 'actual';
    EXEC tSQLt.AssertNotEquals 'Y', 'N';
    EXEC tSQLt.AssertObjectDoesNotExist 'dbo.MyProcedure';
    EXEC tSQLt.AssertObjectExists 'dbo.MyTable';
    EXEC tSQLt.AssertResultSetsHaveSameMetaData
        'SELECT CAST(''A'' AS VARCHAR(1000)) AS name, CAST(30 AS SMALLINT) AS age',
        'SELECT name, age FROM HumanResources.EmployeeAgeReport';
    EXEC tSQLt.Fail
        'Invalid random value returned: ',
        '1', '2', '3', '4', '5', '6', '7', '8', '9';
    EXEC tSQLt.AssertLike '%el%', 'hello';
END;
GO

CREATE PROCEDURE testAPI.[Expectations]
AS
BEGIN
    PRINT 'Expectations:';
    EXEC tSQLt.ExpectException
        @Message = 'Table dbo.DoesNotExist not found.',
        @ExpectedSeverity = 16,
        @ExpectedState = 10;
    EXEC tSQLt.ExpectNoException;
END;
GO

CREATE PROCEDURE testAPI.[Isolating dependencies]
AS
BEGIN
    PRINT 'Isolating dependencies:';
    EXEC tSQLt.ApplyConstraint 'dbo.ReferencingTable','ReferencingTable_ReferencedTable_FK';
    EXEC tSQLt.FakeFunction 'SalesApp.ComputeCommission', 'SalesAppTests.Fake_ComputeCommission';
    EXEC tSQLt.FakeTable 'FinancialApp.CurrencyConversion';
    EXEC tSQLt.RemoveObjectIfExists 'FinancialApp.CurrencyConversion';
    EXEC tSQLt.SpyProcedure 'FinancialApp.CurrentReport';
    EXEC tSQLt.ApplyTrigger 'Registry.Student', 'AuditInserts';
    EXEC tSQLt.RemoveObject 'FinancialApp.CurrencyConversion';
END;
GO

CREATE PROCEDURE testAPI.RunAll
AS
BEGIN
    EXEC testAPI.[Test creation and execution];
    EXEC testAPI.[Assertions];
    EXEC testAPI.[Expectations];
    EXEC testAPI.[Isolating dependencies];
END;
GO