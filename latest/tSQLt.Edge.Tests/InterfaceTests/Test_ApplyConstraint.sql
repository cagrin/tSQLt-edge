CREATE SCHEMA Test_ApplyConstraint;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_TableNotExists
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<Table1> does not exist.'

    EXEC tSQLt.ApplyConstraint 'Table1', 'Constraint1';
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_TableSchemaNotExists
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<Schema1.Table1> does not exist.'

    EXEC tSQLt.ApplyConstraint 'Table1', 'Constraint1', 'Schema1';
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_ConstraintNotExists
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT);

    EXEC tSQLt.FakeTable 'Schema1.Table1';

    EXEC tSQLt.ExpectException 'tSQLt.ApplyConstraint failed. Constraint:<Constraint1> on table <Schema1.Table1> does not exist.'

    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'Constraint1';
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_CheckConstraintApplied
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT CONSTRAINT Check1 CHECK (Column1 = 0));

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'Check1';

    EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'The INSERT statement conflicted with the CHECK constraint "Check1"%, table "Schema1.Table1", column ''Column1''.';

    INSERT INTO Schema1.Table1 (Column1) VALUES (1)
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_MultiColumnCheckConstraintApplied
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT, Column2 INT, CONSTRAINT Check1 CHECK (Column1 = 0 AND Column2 = 0));

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'Check1';

    EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'The INSERT statement conflicted with the CHECK constraint "Check1"%, table "Schema1.Table1".';

    INSERT INTO Schema1.Table1 (Column1, Column2) VALUES (0, 1)
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_PrimaryKeyApplied
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT NOT NULL, CONSTRAINT PrimaryKey1 PRIMARY KEY(Column1));

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'PrimaryKey1';

    EXEC tSQLt.ExpectException 'Violation of PRIMARY KEY constraint ''PrimaryKey1''. Cannot insert duplicate key in object ''Schema1.Table1''. The duplicate key value is (1).';

    INSERT INTO Schema1.Table1 (Column1) VALUES (1), (1)
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_PrimaryKeyApplied_WithDescendingKey
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT NOT NULL, CONSTRAINT PrimaryKey1 PRIMARY KEY(Column1 DESC));

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'PrimaryKey1';

    INSERT INTO Schema1.Table1 (Column1) VALUES (1), (2)

    DECLARE @Actual INT = (SELECT TOP 1 Column1 FROM Schema1.Table1)
    DECLARE @Expected INT = 2

    EXEC tSQLt.AssertEquals @Expected, @Actual;
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_PrimaryKeyApplied_WithClusteredIndex
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT NOT NULL, Column2 INT NOT NULL, CONSTRAINT PrimaryKey1 PRIMARY KEY NONCLUSTERED (Column1));

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    CREATE CLUSTERED INDEX Index1 ON Schema1.Table1 (Column2);
    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'PrimaryKey1';

    EXEC tSQLt.ExpectException 'Violation of PRIMARY KEY constraint ''PrimaryKey1''. Cannot insert duplicate key in object ''Schema1.Table1''. The duplicate key value is (1).';

    INSERT INTO Schema1.Table1 (Column1, Column2) VALUES (1, 2), (1, 2)
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_PrimaryKeyApplied_WithDefault
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT DEFAULT 1 NOT NULL, CONSTRAINT PrimaryKey1 PRIMARY KEY(Column1));

    EXEC tSQLt.FakeTable 'Schema1.Table1', @Defaults = 1;
    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'PrimaryKey1';

    EXEC tSQLt.ExpectException 'Violation of PRIMARY KEY constraint ''PrimaryKey1''. Cannot insert duplicate key in object ''Schema1.Table1''. The duplicate key value is (1).';

    INSERT INTO Schema1.Table1 VALUES (DEFAULT), (DEFAULT)
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_PrimaryKeyApplied_WithIdentity
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT IDENTITY(1,1) NOT NULL, CONSTRAINT PrimaryKey1 PRIMARY KEY(Column1));

    EXEC tSQLt.FakeTable 'Schema1.Table1', @Identity = 1;
    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'PrimaryKey1';

    EXEC tSQLt.ExpectException 'Violation of PRIMARY KEY constraint ''PrimaryKey1''. Cannot insert duplicate key in object ''Schema1.Table1''. The duplicate key value is (1).';

    SET IDENTITY_INSERT Schema1.Table1 ON
    INSERT INTO Schema1.Table1 (Column1) VALUES (1), (1)
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_PrimaryKeyFailed_WithComputedColumn
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT NOT NULL, Column2 AS 2*Column1 PERSISTED, CONSTRAINT PrimaryKey1 PRIMARY KEY(Column2));

    EXEC tSQLt.FakeTable 'Schema1.Table1', @ComputedColumns = 1;

    EXEC tSQLt.ExpectException 'Cannot alter column ''Column2'' because it is ''COMPUTED''.'

    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'PrimaryKey1';
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_UniqueConstraintApplied
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT CONSTRAINT Unique1 UNIQUE (Column1));

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'Unique1';

    EXEC tSQLt.ExpectException 'Violation of UNIQUE KEY constraint ''Unique1''. Cannot insert duplicate key in object ''Schema1.Table1''. The duplicate key value is (1).';

    INSERT INTO Schema1.Table1 (Column1) VALUES (1), (1)
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_MultiColumnUniqueConstraintApplied
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT, Column2 INT, CONSTRAINT Unique1 UNIQUE (Column1, Column2));

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'Unique1';

    EXEC tSQLt.ExpectException 'Violation of UNIQUE KEY constraint ''Unique1''. Cannot insert duplicate key in object ''Schema1.Table1''. The duplicate key value is (0, 1).';

    INSERT INTO Schema1.Table1 (Column1, Column2) VALUES (0, 1), (0, 1)
END;
GO