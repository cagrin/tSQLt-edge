CREATE FUNCTION dbo.TestFunction()
RETURNS TABLE AS
RETURN
SELECT 1 Column1;
GO

CREATE FUNCTION dbo.TestFunctionWithP1(@P1 int)
RETURNS TABLE AS
RETURN
SELECT 1+@P1 Column1;
GO