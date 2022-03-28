CREATE SCHEMA Test_AssertNotEqualsString;
GO

CREATE PROCEDURE Test_AssertNotEqualsString.Test_Hello_Hallo
AS
BEGIN
    EXEC tSQLt.AssertNotEqualsString 'hello', 'hallo';
END;
GO

CREATE PROCEDURE Test_AssertNotEqualsString.Test_Hello_NULL
AS
BEGIN
    EXEC tSQLt.AssertNotEqualsString 'hello', NULL;
END;
GO

CREATE PROCEDURE Test_AssertNotEqualsString.Test_Hello_Hello
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertNotEqualsString failed. Expected any value except:<hello>.';

    EXEC tSQLt.AssertNotEqualsString 'hello', 'hello';
END;
GO

CREATE PROCEDURE Test_AssertNotEqualsString.Test_ErrorMessage
AS
BEGIN
    EXEC tSQLt.ExpectException 'Error message. tSQLt.AssertNotEqualsString failed. Expected any value except:<hello>.';

    EXEC tSQLt.AssertNotEqualsString 'hello', 'hello', 'Error message.';
END;
GO

CREATE PROCEDURE Test_AssertNotEqualsString.Test_NULL_NULL
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertNotEqualsString failed. Expected any value except:<(null)>.';

    EXEC tSQLt.AssertNotEqualsString NULL, NULL;
END;
GO