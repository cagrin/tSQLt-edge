CREATE SCHEMA Test_FakeFunction;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunction
AS
BEGIN
    EXEC('CREATE OR ALTER FUNCTION dbo.TestFunction() RETURNS TABLE AS RETURN SELECT 13 Column1;');
    EXEC('CREATE FUNCTION dbo.FakeFunction() RETURNS TABLE AS RETURN SELECT 42 Column1;');

    EXEC tSQLt.FakeFunction 'dbo.TestFunction', 'dbo.FakeFunction';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunction());

    EXEC tSQLt.AssertEquals 42, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunctionWithP1
AS
BEGIN
    EXEC('CREATE OR ALTER FUNCTION dbo.TestFunctionWithP1(@P1 int) RETURNS TABLE AS RETURN SELECT 13+@P1 Column1;');
    EXEC('CREATE FUNCTION dbo.FakeFunctionWithP1(@P1 int) RETURNS TABLE AS RETURN SELECT 42+@P1 Column1;');

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionWithP1', 'dbo.FakeFunctionWithP1';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionWithP1(1));

    EXEC tSQLt.AssertEquals 43, @Actual;
END;
GO