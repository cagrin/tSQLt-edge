CREATE SCHEMA Test_TestClasses;
GO

CREATE PROCEDURE Test_TestClasses.Test_ResultSet
AS
BEGIN
    CREATE TABLE #Expected
    (
       	[Name] SYSNAME COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	    [SchemaId] INT NOT NULL
    )

    EXEC tSQLt.AssertResultSetsHaveSameMetaData 'SELECT * FROM #Expected', 'SELECT * FROM tSQLt.TestClasses';
END;
GO