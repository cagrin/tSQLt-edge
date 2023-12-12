CREATE SCHEMA Test_Tests;
GO

CREATE PROCEDURE Test_Tests.Test_ResultSet
AS
BEGIN
    CREATE TABLE #Expected
    (
	    [SchemaId] INT NOT NULL,
        [TestClassName] SYSNAME COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
        [ObjectId] INT NOT NULL,
       	[Name] SYSNAME COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
    );

    EXEC tSQLt.AssertResultSetsHaveSameMetaData 'SELECT * FROM #Expected', 'SELECT * FROM tSQLt.Tests';
END;
GO