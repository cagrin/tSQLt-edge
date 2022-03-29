CREATE SCHEMA Test_FakeFunction;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunction
AS
BEGIN
    EXEC('CREATE OR ALTER FUNCTION dbo.TestFunctionIF() RETURNS TABLE AS RETURN SELECT 13 Column1;');
    EXEC('CREATE FUNCTION dbo.FakeFunction() RETURNS TABLE AS RETURN SELECT 42 Column1;');

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF', 'dbo.FakeFunction';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionIF());

    EXEC tSQLt.AssertEquals 42, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_InlineTableValuedFunctionWithP1
AS
BEGIN
    EXEC('CREATE OR ALTER FUNCTION dbo.TestFunctionIF_P1(@P1 int) RETURNS TABLE AS RETURN SELECT 13+@P1 Column1;');
    EXEC('CREATE FUNCTION dbo.FakeFunction(@P1 int) RETURNS TABLE AS RETURN SELECT 42+@P1 Column1;');

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionIF_P1', 'dbo.FakeFunction';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionIF_P1(1));

    EXEC tSQLt.AssertEquals 43, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_MultiStatementTableValuedFunction
AS
BEGIN
    EXEC('CREATE OR ALTER FUNCTION dbo.TestFunctionTF() RETURNS @Result TABLE (Column1 int) AS BEGIN INSERT INTO @Result SELECT 13; RETURN; END;');
    EXEC('CREATE FUNCTION dbo.FakeFunction() RETURNS @Result TABLE (Column1 int) AS BEGIN INSERT INTO @Result SELECT 42; RETURN; END;');

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionTF', 'dbo.FakeFunction';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionTF());

    EXEC tSQLt.AssertEquals 42, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_MultiStatementTableValuedFunctionWithP1
AS
BEGIN
    EXEC('CREATE OR ALTER FUNCTION dbo.TestFunctionTF_P1(@P1 int) RETURNS @Result TABLE (Column1 int) AS BEGIN INSERT INTO @Result SELECT 13+@P1; RETURN; END;');
    EXEC('CREATE FUNCTION dbo.FakeFunction(@P1 int) RETURNS @Result TABLE (Column1 int) AS BEGIN INSERT INTO @Result SELECT 42+@P1; RETURN; END;');

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionTF_P1', 'dbo.FakeFunction';

    DECLARE @Actual INT = (SELECT Column1 FROM dbo.TestFunctionTF_P1(1));

    EXEC tSQLt.AssertEquals 43, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ScalarFunction
AS
BEGIN
    EXEC('CREATE OR ALTER FUNCTION dbo.TestFunctionScalar() RETURNS INT AS BEGIN RETURN (SELECT 13); END;');
    EXEC('CREATE FUNCTION dbo.FakeFunction() RETURNS INT AS BEGIN RETURN (SELECT 42); END;');

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar', 'dbo.FakeFunction';

    DECLARE @Actual INT = dbo.TestFunctionScalar();

    EXEC tSQLt.AssertEquals 42, @Actual;
END;
GO

CREATE PROCEDURE Test_FakeFunction.Test_ScalarFunctionWithP1
AS
BEGIN
    EXEC('CREATE OR ALTER FUNCTION dbo.TestFunctionScalar_P1(@P1 int) RETURNS INT AS BEGIN RETURN (SELECT 13+@P1); END;');
    EXEC('CREATE FUNCTION dbo.FakeFunction(@P1 int) RETURNS INT AS BEGIN RETURN (SELECT 42+@P1); END;');

    EXEC tSQLt.FakeFunction 'dbo.TestFunctionScalar_P1', 'dbo.FakeFunction';

    DECLARE @Actual INT = dbo.TestFunctionScalar_P1(1);

    EXEC tSQLt.AssertEquals 43, @Actual;
END;
GO