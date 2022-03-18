CREATE SCHEMA Test_Fail;
GO

CREATE PROCEDURE Test_Fail.Test_Raiserror
AS
BEGIN
    EXEC tSQLt.ExpectException 'Test_Raiserror';

    EXEC tSQLt.Fail 'Test_Raiserror';
END;
GO

CREATE PROCEDURE Test_Fail.Test_Raiserror_Message9
AS
BEGIN
    EXEC tSQLt.ExpectException 'Test_Raiserror M1 M2 M3 M4 M5 M6 M7 M8 M9';

    EXEC tSQLt.Fail 'Test_Raiserror', 'M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8', @Message9 = 'M9';
END;
GO