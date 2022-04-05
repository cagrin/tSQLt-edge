CREATE SCHEMA Test_FakeFunction;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunction
AS
BEGIN
    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF', 'dbo.FakeFunctionIF';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionIF());

    EXEC tSQLt.AssertEquals 42, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunctionWithP1
AS
BEGIN
    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF_P1', 'dbo.FakeFunctionIF_P1';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionIF_P1(1));

    EXEC tSQLt.AssertEquals 43, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_MultiStatementTableValuedFunction
AS
BEGIN
    EXEC tSQLt.FakeFunction 'dbo.TestFunctionTF', 'dbo.FakeFunctionTF';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionTF());

    EXEC tSQLt.AssertEquals 42, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_MultiStatementTableValuedFunctionWithP1
AS
BEGIN
    EXEC tSQLt.FakeFunction 'dbo.TestFunctionTF_P1', 'dbo.FakeFunctionTF_P1';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionTF_P1(1));

    EXEC tSQLt.AssertEquals 43, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ScalarFunction
AS
BEGIN
    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar', 'dbo.FakeFunctionScalar';

    DECLARE @Actual INT = dbo.TestFunctionScalar();

    EXEC tSQLt.AssertEquals 42, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ScalarFunctionWithP1
AS
BEGIN
    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar_P1', 'dbo.FakeFunctionScalar_P1';

    DECLARE @Actual INT = dbo.TestFunctionScalar_P1(1);

    EXEC tSQLt.AssertEquals 43, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ScalarFunction_FakeFunctionIsNull
AS
BEGIN
    EXEC tSQLt.ExpectException 'Either @FakeFunctionName or @FakeDataSource must be provided.';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar', NULL;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ScalarFunction_FunctionIsNull
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<(null)> does not exist.';

    EXEC tSQLt.FakeFunction NULL, 'dbo.FakeFunctionScalar';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunction_DataSourceIsNotNull
AS
BEGIN
    EXEC tSQLt.ExpectException 'Both @FakeFunctionName and @FakeDataSource are valued. Please use only one.';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF', 'dbo.FakeFunctionIF', 'dbo.FakeDataSource';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunction_DataSourceIsSelect
AS
BEGIN
    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF', @FakeDataSource = 'SELECT 5 AS Column1';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionIF());

    EXEC tSQLt.AssertEquals 5, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunction_DataSourceIsTable
AS
BEGIN
    CREATE TABLE dbo.FakeDataSourceIF (Column1 int);
    INSERT INTO dbo.FakeDataSourceIF VALUES (6);

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF', @FakeDataSource = 'dbo.FakeDataSourceIF';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionIF());

    EXEC tSQLt.AssertEquals 6, @Actual;
END;
GO