CREATE SCHEMA Test_ApplyConstraint;
GO

CREATE PROCEDURE Test_ApplyConstraint.TableNotExists
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<Table1> does not exist.'

    EXEC tSQLt.ApplyConstraint 'Table1', 'Constraint1';
END;
GO

CREATE PROCEDURE Test_ApplyConstraint.[test ApplyConstraint copies a check constraint to a fake table]
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    CREATE TABLE Schema1.Table1 (Column1 INT CONSTRAINT Constraint1 CHECK (Column1 = 0));

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    EXEC tSQLt.ApplyConstraint 'Schema1.Table1', 'Constraint1';

    EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'The INSERT statement conflicted with the CHECK constraint "Constraint1"%, table "Schema1.Table1", column ''Column1''.';

    INSERT INTO Schema1.Table1 (Column1) VALUES (1)
END;
GO