CREATE SCHEMA Test_ApplyTrigger;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_TableNotExists
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<TableName1> does not exist.'

    EXEC tSQLt.ApplyTrigger 'TableName1', 'TriggerName1';
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_TriggerNotExists
AS
BEGIN
    CREATE TABLE TableName1 (Column1 INT);

    EXEC tSQLt.ExpectException 'tSQLt.AssertObjectExists failed. Object:<dbo.TriggerName1> does not exist.'

    EXEC tSQLt.ApplyTrigger 'TableName1', 'TriggerName1';
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_IsTriggered
AS
BEGIN
    CREATE TABLE TableName1 (Column1 INT);
    EXEC('CREATE TRIGGER TriggerName1 ON TableName1 INSTEAD OF INSERT AS BEGIN RAISERROR(N''TriggerName1 triggered!'', 16, 10); END;');

    EXEC tSQLt.ExpectException 'TriggerName1 triggered!';

    INSERT INTO TableName1 (Column1) VALUES (1);
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_IsNotTriggeredAfterFakeTable
AS
BEGIN
    CREATE TABLE TableName1 (Column1 INT);
    EXEC('CREATE TRIGGER TriggerName1 ON TableName1 INSTEAD OF INSERT AS BEGIN RAISERROR(N''TriggerName1 triggered!'', 16, 10); END;');

    EXEC tSQLt.FakeTable 'TableName1';

    INSERT INTO TableName1 (Column1) VALUES (1);
END;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_IsTriggeredAfterFakeTableAndApplyTrigger
AS
BEGIN
    CREATE TABLE TableName1 (Column1 INT);
    EXEC('CREATE TRIGGER TriggerName1 ON TableName1 INSTEAD OF INSERT AS BEGIN RAISERROR(N''TriggerName1 triggered!'', 16, 10); END;');

    EXEC tSQLt.ExpectException 'TriggerName1 triggered!';

    EXEC tSQLt.FakeTable 'TableName1';
    EXEC tSQLt.ApplyTrigger 'TableName1', 'TriggerName1';

    INSERT INTO TableName1 (Column1) VALUES (1);
END;
GO


CREATE PROCEDURE Test_ApplyTrigger.Test_IsTriggeredAfterFakeTableAndApplyTrigger_Schema
AS
BEGIN
    CREATE TABLE Test_ApplyTrigger.TableName2 (Column2 INT);
    EXEC('CREATE TRIGGER TriggerName2 ON Test_ApplyTrigger.TableName2 INSTEAD OF INSERT AS BEGIN RAISERROR(N''TriggerName2 triggered!'', 16, 10); END;');

    EXEC tSQLt.ExpectException 'TriggerName2 triggered!';

    EXEC tSQLt.FakeTable 'Test_ApplyTrigger.TableName2';
    EXEC tSQLt.ApplyTrigger 'Test_ApplyTrigger.TableName2', 'TriggerName2';

    INSERT INTO Test_ApplyTrigger.TableName2 (Column2) VALUES (2);
END;
GO