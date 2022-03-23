CREATE SCHEMA Test_Fail;
GO

CREATE PROCEDURE Test_Fail.Test_Raiserror
AS
BEGIN
    EXEC tSQLt.ExpectException 'Test_Raiserror';

    EXEC tSQLt.Fail 'Test_Raiserror';
END;
GO

CREATE PROCEDURE Test_Fail.Test_Raiserror_AllMessages
AS
BEGIN
    EXEC tSQLt.ExpectException 'Test_Raiserror M1 M2 M3 M4 M5 M6 M7 M8 M9';

    EXEC tSQLt.Fail 'Test_Raiserror', 'M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8', 'M9';
END;
GO

CREATE PROCEDURE Test_Fail.Test_Raiserror_Null
AS
BEGIN
    EXEC tSQLt.ExpectException '';

    EXEC tSQLt.Fail NULL;
END;
GO

CREATE PROCEDURE Test_Fail.Test_Raiserror_OnlyMessage9
AS
BEGIN
    EXEC tSQLt.ExpectException 'M9';

    EXEC tSQLt.Fail @Message9 = 'M9';
END;
GO

CREATE PROCEDURE Test_Fail.Test_Raiserror_Message5_9
AS
BEGIN
    EXEC tSQLt.ExpectException 'Test_Raiserror M5 M9';

    EXEC tSQLt.Fail 'Test_Raiserror', NULL, NULL, NULL, NULL, @Message5 = 'M5', @Message9 = 'M9';
END;
GO

CREATE PROCEDURE Test_Fail.Test_Raiserror_SpecialCharacters
AS
BEGIN
    EXEC tSQLt.ExpectException 'Test_Raiserror !@#$%^&*() -=[];''\,./ _+{}:"|<>?';

    EXEC tSQLt.Fail 'Test_Raiserror', '!@#$%^&*()', '-=[];''\,./', '_+{}:"|<>?';
END;
GO