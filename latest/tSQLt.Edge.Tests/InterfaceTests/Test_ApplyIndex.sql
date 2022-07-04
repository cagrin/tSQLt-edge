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

CREATE PROCEDURE Test_ApplyIndex.Test_FilteredUniqueIndexApplied
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT, Column2 CHAR(1));
    CREATE UNIQUE INDEX FilteredUniqueIndex1 ON Schema1.Table1 (Column1) WHERE Column2 = 'Y'

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    EXEC tSQLt.ApplyIndex 'Schema1.Table1', 'FilteredUniqueIndex1';

    INSERT INTO Schema1.Table1 (Column1, Column2) VALUES (1, 'Y'), (1, 'N'), (2, 'Y')

    EXEC tSQLt.ExpectException 'Cannot insert duplicate key row in object ''Schema1.Table1'' with unique index ''FilteredUniqueIndex1''. The duplicate key value is (1).'

    INSERT INTO Schema1.Table1 (Column1, Column2) VALUES (1, 'Y')
END;
GO

CREATE PROCEDURE Test_ApplyIndex.Test_ClusteredIndexApplied
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT NOT NULL);
    CREATE CLUSTERED INDEX ClusteredIndex1 ON Schema1.Table1 (Column1);

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    EXEC tSQLt.ApplyIndex 'Schema1.Table1', 'ClusteredIndex1';

    EXEC tSQLt.ExpectException 'Cannot create more than one clustered index on table ''Schema1.Table1''. Drop the existing clustered index ''ClusteredIndex1'' before creating another.';

    CREATE CLUSTERED INDEX ClusteredIndex2 ON Schema1.Table1 (Column1);
END;
GO