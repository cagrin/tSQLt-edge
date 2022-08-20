CREATE SCHEMA Test_ApplyTrigger;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_TableNotExists
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<Table1> does not exist.'

    EXEC tSQLt.ApplyTrigger 'Table1', 'Trigger1';
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_TriggerNotExists
AS
BEGIN
    CREATE TABLE Table1 (Column1 INT);

    EXEC tSQLt.FakeTable 'Table1';

    EXEC tSQLt.ExpectException 'tSQLt.ApplyTrigger failed. Trigger:<Trigger1> on table <Table1> does not exist.'

    EXEC tSQLt.ApplyTrigger 'Table1', 'Trigger1';
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_IsTriggered
AS
BEGIN
    CREATE TABLE Table1 (Column1 INT);
    EXEC('CREATE TRIGGER Trigger1 ON Table1 INSTEAD OF INSERT AS BEGIN RAISERROR(N''Trigger1 triggered!'', 16, 10); END;');

    EXEC tSQLt.ExpectException 'Trigger1 triggered!';

    INSERT INTO Table1 (Column1) VALUES (1);
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_IsNotTriggeredAfterFakeTable
AS
BEGIN
    CREATE TABLE Table1 (Column1 INT);
    EXEC('CREATE TRIGGER Trigger1 ON Table1 INSTEAD OF INSERT AS BEGIN RAISERROR(N''Trigger1 triggered!'', 16, 10); END;');

    EXEC tSQLt.FakeTable 'Table1';

    INSERT INTO Table1 (Column1) VALUES (1);
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_IsTriggeredAfterFakeTableAndApplyTrigger
AS
BEGIN
    CREATE TABLE Table1 (Column1 INT);
    EXEC('CREATE TRIGGER Trigger1 ON Table1 INSTEAD OF INSERT AS BEGIN RAISERROR(N''Trigger1 triggered!'', 16, 10); END;');

    EXEC tSQLt.FakeTable 'Table1';
    EXEC tSQLt.ApplyTrigger 'Table1', 'Trigger1';

    EXEC tSQLt.ExpectException 'Trigger1 triggered!';

    INSERT INTO Table1 (Column1) VALUES (1);
END;
GO


CREATE PROCEDURE Test_ApplyTrigger.Test_IsTriggeredAfterFakeTableAndApplyTrigger_Schema
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    EXEC('CREATE TABLE Schema1.Table1 (Column1 INT);');
    EXEC('CREATE TRIGGER Trigger1 ON Schema1.Table1 INSTEAD OF INSERT AS BEGIN RAISERROR(N''Trigger1 triggered!'', 16, 10); END;');

    EXEC tSQLt.FakeTable 'Schema1.Table1';
    EXEC tSQLt.ApplyTrigger 'Schema1.Table1', 'Trigger1';

    EXEC tSQLt.ExpectException 'Trigger1 triggered!';

    EXEC('INSERT INTO Schema1.Table1 (Column1) VALUES (2);');
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_FailWhenTableWasNotFaked
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    EXEC('CREATE TABLE Schema1.Table1 (Column1 INT);');
    EXEC('CREATE TRIGGER Trigger1 ON Schema1.Table1 INSTEAD OF INSERT AS BEGIN RAISERROR(N''Trigger1 triggered!'', 16, 10); END;');

    EXEC tSQLt.ExpectException 'Table Schema1.Table1 was not faked by tSQLt.FakeTable.';

    EXEC tSQLt.ApplyTrigger 'Schema1.Table1', 'Trigger1';
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_TriggerExistsOnOtherTable
AS
BEGIN
    EXEC('CREATE SCHEMA Schema1;');
    EXEC('CREATE TABLE Schema1.Table1 (Column1 INT);');
    EXEC('CREATE TABLE Schema1.Table2 (Column1 INT);');
    EXEC('CREATE TRIGGER Trigger1 ON Schema1.Table2 INSTEAD OF INSERT AS BEGIN RAISERROR(N''Trigger1 triggered!'', 16, 10); END;');

    EXEC tSQLt.FakeTable 'Schema1.Table1';

    EXEC tSQLt.ExpectException 'tSQLt.ApplyTrigger failed. Trigger:<Trigger1> on table <Schema1.Table1> does not exist.'

    EXEC tSQLt.ApplyTrigger 'Schema1.Table1', 'Trigger1';
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_IsExternalTriggeredAfterFakeTableAndApplyTrigger
AS
BEGIN
    CREATE TABLE master.dbo.Table1 (Column1 INT);
    EXEC('USE master; EXEC(''CREATE TRIGGER Trigger1 ON Table1 INSTEAD OF INSERT AS BEGIN RAISERROR(N''''Trigger1 triggered!'''', 16, 10); END;'');');

    EXEC tSQLt.FakeTable 'master.dbo.Table1';
    EXEC tSQLt.ApplyTrigger 'master.dbo.Table1', 'Trigger1';

    EXEC tSQLt.ExpectException 'Trigger1 triggered!';

    INSERT INTO master.dbo.Table1 (Column1) VALUES (1);
END;
GO