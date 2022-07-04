CREATE SCHEMA Test_ApplyIndex;
GO

CREATE PROCEDURE Test_ApplyIndex.Test_IndexNotExists
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT);

    EXEC tSQLt.FakeTable 'Schema1.Table1';

    EXEC tSQLt.ExpectException 'tSQLt.ApplyIndex failed. Index:<Index1> on table <Schema1.Table1> does not exist.'

    EXEC tSQLt.ApplyIndex 'Schema1.Table1', 'Index1';
END;
GO