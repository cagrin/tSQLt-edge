CREATE SCHEMA Test_AssertEqualsTableSchema;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_TwoIdenticalTables
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 INT);');
    EXEC ('CREATE TABLE dbo.TestTable2 (Column1 INT);');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO