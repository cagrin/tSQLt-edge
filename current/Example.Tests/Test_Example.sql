CREATE SCHEMA [Test_Example];
GO

CREATE PROCEDURE [Test_Example].[Test_Avg]
AS
BEGIN
    EXEC tSQLt.FakeTable 'dbo.ExampleTable';
    INSERT INTO dbo.ExampleTable (Amount) VALUES (2), (3), (5);

    CREATE TABLE #Expected (Amount DECIMAL(13,3) NOT NULL);
    INSERT INTO #Expected SELECT 3.333;

    CREATE TABLE #Actual (Amount DECIMAL(13,3) NOT NULL);
    INSERT INTO #Actual EXEC ExampleProcedure;

    EXEC tSQLt.AssertEqualsTable '#Expected', '#Actual';
END;
GO