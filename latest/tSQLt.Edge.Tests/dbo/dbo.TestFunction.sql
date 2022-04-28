CREATE SCHEMA Test_TestFunction;
GO

CREATE PROCEDURE Test_TestFunction.Test_Coverage
AS
BEGIN
    DECLARE @Column1 INT, @P1 INT, @P2 dbo.TestType;

    SET @Column1 = (SELECT Column1 FROM dbo.TestFunctionIF());
    SET @Column1 = (SELECT Column1 FROM dbo.FakeFunctionIF());

    SET @Column1 = (SELECT Column1 FROM dbo.TestFunctionIF_P1(@P1));
    SET @Column1 = (SELECT Column1 FROM dbo.FakeFunctionIF_P1(@P1));

    SET @Column1 = (SELECT Column1 FROM dbo.TestFunctionTF());
    SET @Column1 = (SELECT Column1 FROM dbo.FakeFunctionTF());

    SET @Column1 = (SELECT Column1 FROM dbo.TestFunctionTF_P1(@P1));
    SET @Column1 = (SELECT Column1 FROM dbo.FakeFunctionTF_P1(@P1));

    SET @Column1 = dbo.TestFunctionScalar();
    SET @Column1 = dbo.FakeFunctionScalar();

    SET @Column1 = dbo.TestFunctionScalar_P1(@P1);
    SET @Column1 = dbo.FakeFunctionScalar_P1(@P1);

    SET @Column1 = (SELECT Column1 FROM dbo.TestFunctionIF_P1_TT(@P1, @P2));
    SET @Column1 = (SELECT Column1 FROM dbo.FakeFunctionIF_P1_TT(@P1, @P2));

    SET @Column1 = (SELECT Column1 FROM dbo.TestFunctionTF_P1_TT(@P1, @P2));
    SET @Column1 = (SELECT Column1 FROM dbo.FakeFunctionTF_P1_TT(@P1, @P2));

    SET @Column1 = dbo.TestFunctionScalar_P1_TT(@P1, @P2);
    SET @Column1 = dbo.FakeFunctionScalar_P1_TT(@P1, @P2);
END;
GO

CREATE FUNCTION dbo.TestFunctionIF() RETURNS TABLE AS RETURN SELECT 13 Column1;
GO
CREATE FUNCTION dbo.FakeFunctionIF() RETURNS TABLE AS RETURN SELECT 42 Column1;
GO

CREATE FUNCTION dbo.TestFunctionIF_P1(@P1 int) RETURNS TABLE AS RETURN SELECT 13+@P1 Column1;
GO
CREATE FUNCTION dbo.FakeFunctionIF_P1(@P1 int) RETURNS TABLE AS RETURN SELECT 42+@P1 Column1;
GO

CREATE FUNCTION dbo.TestFunctionTF() RETURNS @Result TABLE (Column1 int) AS BEGIN INSERT INTO @Result SELECT 13; RETURN; END;
GO
CREATE FUNCTION dbo.FakeFunctionTF() RETURNS @Result TABLE (Column1 int) AS BEGIN INSERT INTO @Result SELECT 42; RETURN; END;
GO

CREATE FUNCTION dbo.TestFunctionTF_P1(@P1 int) RETURNS @Result TABLE (Column1 int) AS BEGIN INSERT INTO @Result SELECT 13+@P1; RETURN; END;
GO
CREATE FUNCTION dbo.FakeFunctionTF_P1(@P1 int) RETURNS @Result TABLE (Column1 int) AS BEGIN INSERT INTO @Result SELECT 42+@P1; RETURN; END;
GO

CREATE FUNCTION dbo.TestFunctionScalar() RETURNS INT AS BEGIN RETURN (SELECT 13); END;
GO
CREATE FUNCTION dbo.FakeFunctionScalar() RETURNS INT AS BEGIN RETURN (SELECT 42); END;
GO

CREATE FUNCTION dbo.TestFunctionScalar_P1(@P1 int) RETURNS INT AS BEGIN RETURN (SELECT 13+@P1); END;
GO
CREATE FUNCTION dbo.FakeFunctionScalar_P1(@P1 int) RETURNS INT AS BEGIN RETURN (SELECT 42+@P1); END;
GO

CREATE FUNCTION dbo.TestFunctionIF_P1_TT(@P1 int, @P2 dbo.TestType READONLY) RETURNS TABLE AS RETURN SELECT (SELECT 13+SUM(Column1)+@P1 FROM @P2) Column1;
GO
CREATE FUNCTION dbo.FakeFunctionIF_P1_TT(@P1 int, @P2 dbo.TestType READONLY) RETURNS TABLE AS RETURN SELECT (SELECT 42+SUM(Column1)+@P1 FROM @P2) Column1;
GO

CREATE FUNCTION dbo.TestFunctionTF_P1_TT(@P1 int, @P2 dbo.TestType READONLY) RETURNS @Result TABLE (Column1 int) AS BEGIN INSERT INTO @Result SELECT 13+SUM(Column1)+@P1 FROM @P2; RETURN; END;
GO
CREATE FUNCTION dbo.FakeFunctionTF_P1_TT(@P1 int, @P2 dbo.TestType READONLY) RETURNS @Result TABLE (Column1 int) AS BEGIN INSERT INTO @Result SELECT 42+SUM(Column1)+@P1 FROM @P2; RETURN; END;
GO

CREATE FUNCTION dbo.TestFunctionScalar_P1_TT(@P1 int, @P2 dbo.TestType READONLY) RETURNS INT AS BEGIN RETURN (SELECT 13+SUM(Column1)+@P1 FROM @P2); END;
GO
CREATE FUNCTION dbo.FakeFunctionScalar_P1_TT(@P1 int, @P2 dbo.TestType READONLY) RETURNS INT AS BEGIN RETURN (SELECT 42+SUM(Column1)+@P1 FROM @P2); END;
GO