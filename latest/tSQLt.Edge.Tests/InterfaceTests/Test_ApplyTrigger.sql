CREATE SCHEMA Test_ApplyTrigger;
GO

CREATE PROCEDURE Test_ApplyTrigger.Test_IsUnsupported
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.ApplyTrigger is not yet supported.'

    EXEC tSQLt.ApplyTrigger 'TableName1', 'TriggerName1';
END;
GO