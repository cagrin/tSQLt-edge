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
    CREATE TABLE dbo.FakeDataSource (Column1 int);
    INSERT INTO dbo.FakeDataSource VALUES (6);

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF', @FakeDataSource = 'dbo.FakeDataSource';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionIF());

    EXEC tSQLt.AssertEquals 6, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunctionWithP1_TT
AS
BEGIN
    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF_P1_TT', 'dbo.FakeFunctionIF_P1_TT';

    DECLARE @P1 int = 1;
    DECLARE @P2 dbo.TestType;
    INSERT INTO @P2(Column1) VALUES (2);

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionIF_P1_TT(@P1, @P2));

    EXEC tSQLt.AssertEquals 45, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_MultiStatementTableValuedFunctionWithP1_TT
AS
BEGIN
    EXEC tSQLt.FakeFunction 'dbo.TestFunctionTF_P1_TT', 'dbo.FakeFunctionTF_P1_TT';

    DECLARE @P1 int = 1;
    DECLARE @P2 dbo.TestType;
    INSERT INTO @P2(Column1) VALUES (2);
    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionTF_P1_TT(@P1, @P2));

    EXEC tSQLt.AssertEquals 45, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ScalarFunctionWithP1_TT
AS
BEGIN
    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar_P1_TT', 'dbo.FakeFunctionScalar_P1_TT';

    DECLARE @P1 int = 1;
    DECLARE @P2 dbo.TestType;
    INSERT INTO @P2(Column1) VALUES (2);
    DECLARE @Actual INT = dbo.TestFunctionScalar_P1_TT(@P1, @P2);

    EXEC tSQLt.AssertEquals 45, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunction_Mismatch
AS
BEGIN
    EXEC tSQLt.ExpectException 'Parameters of both functions must match! (This includes the return type for scalar functions.)';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF', 'dbo.FakeFunctionIF_P1';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunctionWithP1_Mismatch
AS
BEGIN
    EXEC tSQLt.ExpectException 'Parameters of both functions must match! (This includes the return type for scalar functions.)';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF_P1', 'dbo.FakeFunctionIF_P1_TT';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunctionWithP1_TT_Mismatch
AS
BEGIN
    EXEC tSQLt.ExpectException 'Parameters of both functions must match! (This includes the return type for scalar functions.)';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF_P1_TT', 'dbo.FakeFunctionIF';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_MultiStatementTableValuedFunction_Mismatch
AS
BEGIN
    EXEC tSQLt.ExpectException 'Parameters of both functions must match! (This includes the return type for scalar functions.)';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionTF', 'dbo.FakeFunctionTF_P1';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_MultiStatementTableValuedFunctionWithP1_Mismatch
AS
BEGIN
    EXEC tSQLt.ExpectException 'Parameters of both functions must match! (This includes the return type for scalar functions.)';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionTF_P1', 'dbo.FakeFunctionTF_P1_TT';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_MultiStatementTableValuedFunctionWithP1_TT_Mismatch
AS
BEGIN
    EXEC tSQLt.ExpectException 'Parameters of both functions must match! (This includes the return type for scalar functions.)';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionTF_P1_TT', 'dbo.FakeFunctionTF';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ScalarFunction_Mismatch
AS
BEGIN
    EXEC tSQLt.ExpectException 'Parameters of both functions must match! (This includes the return type for scalar functions.)';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar', 'dbo.FakeFunctionScalar_P1';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ScalarFunctionWithP1_Mismatch
AS
BEGIN
    EXEC tSQLt.ExpectException 'Parameters of both functions must match! (This includes the return type for scalar functions.)';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar_P1', 'dbo.FakeFunctionScalar_P1_TT';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ScalarFunctionWithP1_TT_Mismatch
AS
BEGIN
    EXEC tSQLt.ExpectException 'Parameters of both functions must match! (This includes the return type for scalar functions.)';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar_P1_TT', 'dbo.FakeFunctionScalar';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_Failed_When_Procedure
AS
BEGIN
    EXEC tSQLt.ExpectException 'Both parameters must contain the name of either scalar or table valued functions';

    EXEC tSQLt.FakeFunction 'dbo.TestProcedure', 'dbo.FakeFunctionIF';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_Failed_When_UnsuportedFunctionType
AS
BEGIN
    EXEC Test_Extensions.FakeObjectType 'dbo.TestFunctionScalar', 'AF';

    EXEC tSQLt.ExpectException 'Both parameters must contain the name of either scalar or table valued functions';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar', 'dbo.FakeFunctionScalar';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_Can_Fake_Assembly_CLR_ScalarFunction
AS
BEGIN
    EXEC Test_Extensions.FakeObjectType 'dbo.TestFunctionScalar', 'FS';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar', 'dbo.FakeFunctionScalar';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_Can_Fake_Assembly_CLR_TableValuedFunction
AS
BEGIN
    EXEC Test_Extensions.FakeObjectType 'dbo.TestFunctionIF', 'FT';

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF', 'dbo.FakeFunctionIF';
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ExternalInlineTableValuedFunction
AS
BEGIN
    EXEC('USE master; EXEC(''CREATE SCHEMA Schema1;'')');
    EXEC ('USE master; EXEC(''CREATE FUNCTION Schema1.TestFunctionIF() RETURNS TABLE AS RETURN SELECT 13 Column1;'')');
    EXEC ('USE master; EXEC(''CREATE FUNCTION Schema1.FakeFunctionIF() RETURNS TABLE AS RETURN SELECT 42 Column1;'')');

    EXEC tSQLt.FakeFunction 'master.Schema1.TestFunctionIF', 'master.Schema1.FakeFunctionIF';

    DECLARE @Actual INT;
    EXEC sys.sp_executesql N'SET @Actual = (SELECT Column1 FROM master.Schema1.TestFunctionIF())', N'@Actual INT OUTPUT', @Actual OUTPUT;

    EXEC tSQLt.AssertEquals 42, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ExternalScalarFunctionWithP1
AS
BEGIN
    EXEC('USE master; EXEC(''CREATE SCHEMA Schema1;'')');
    EXEC ('USE master; EXEC(''CREATE FUNCTION Schema1.TestFunctionScalar_P1(@P1 int) RETURNS INT AS BEGIN RETURN (SELECT 13+@P1); END;'')');
    EXEC ('USE master; EXEC(''CREATE FUNCTION Schema1.FakeFunctionScalar_P1(@P1 int) RETURNS INT AS BEGIN RETURN (SELECT 42+@P1); END;'')');

    EXEC tSQLt.FakeFunction 'master.Schema1.TestFunctionScalar_P1', 'master.Schema1.FakeFunctionScalar_P1';

    DECLARE @Actual INT;
    EXEC sys.sp_executesql N'SET @Actual = master.Schema1.TestFunctionScalar_P1(1)', N'@Actual INT OUTPUT', @Actual OUTPUT;

    EXEC tSQLt.AssertEquals 43, @Actual;
END;
GO
