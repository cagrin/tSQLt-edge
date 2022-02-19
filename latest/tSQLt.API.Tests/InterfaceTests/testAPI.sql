CREATE SCHEMA testAPI;
GO

CREATE PROCEDURE testAPI.[Test creation and execution]
AS
BEGIN
    PRINT 'Test creation and execution:';
    EXEC tSQLt.NewTestClass '@ClassName';
    EXEC tSQLt.DropClass '@ClassName';
    EXEC tSQLt.RunAll;
    EXEC tSQLt.Run '@TestName';
    EXEC tSQLt.RenameClass '@SchemaName', '@NewSchemaName';
END;
GO

CREATE PROCEDURE testAPI.[Assertions]
AS
BEGIN
    PRINT 'Assertions:';
    EXEC tSQLt.AssertEmptyTable '@TableName', '@Message';
    EXEC tSQLt.AssertEquals '@Expected', '@Actual', '@Message';
    EXEC tSQLt.AssertEqualsString '@Expected', '@Actual', '@Message';
    EXEC tSQLt.AssertEqualsTable '@Expected', '@Actual', '@Message', '@FailMsg';
    EXEC tSQLt.AssertEqualsTableSchema '@Expected', '@Actual', '@Message';
    EXEC tSQLt.AssertNotEquals '@Expected', '@Actual', '@Message';
    EXEC tSQLt.AssertObjectDoesNotExist '@ObjectName', '@Message';
    EXEC tSQLt.AssertObjectExists '@ObjectName', '@Message';
    EXEC tSQLt.AssertResultSetsHaveSameMetaData '@expectedCommand', '@actualCommand';
    EXEC tSQLt.Fail '@Message0', '@Message1', '@Message2', '@Message3', '@Message4', '@Message5', '@Message6', '@Message7', '@Message8', '@Message9';
    EXEC tSQLt.AssertLike '@ExpectedPattern', '@Actual', '@Message';
END;
GO

CREATE PROCEDURE testAPI.[Expectations]
AS
BEGIN
    PRINT 'Expectations:';
    EXEC tSQLt.ExpectException '@ExpectedMessage', NULL, NULL, '@Message', '@ExpectedMessagePattern', NULL;
    EXEC tSQLt.ExpectNoException '@Message';
END;
GO

CREATE PROCEDURE testAPI.[Isolating dependencies]
AS
BEGIN
    PRINT 'Isolating dependencies:';
    EXEC tSQLt.ApplyConstraint '@TableName', '@ConstraintName', '@SchemaName', NULL;
    EXEC tSQLt.FakeFunction '@FunctionName', '@FakeFunctionName', '@FakeDataSource';
    EXEC tSQLt.FakeTable '@TableName', '@SchemaName', NULL, NULL, NULL;
    EXEC tSQLt.RemoveObjectIfExists '@ObjectName';
    EXEC tSQLt.SpyProcedure '@ProcedureName', '@CommandToExecute';
    EXEC tSQLt.ApplyTrigger '@TableName', '@TriggerName';
    EXEC tSQLt.RemoveObject '@ObjectName';
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