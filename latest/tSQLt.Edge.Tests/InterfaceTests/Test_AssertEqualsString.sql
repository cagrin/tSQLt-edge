CREATE SCHEMA Test_AssertEqualsString;
GO

CREATE PROCEDURE Test_AssertEqualsString.Test_Hello_Hello
AS
BEGIN
    EXEC tSQLt.AssertEqualsString 'hello', 'hello';
END;
GO

CREATE PROCEDURE Test_AssertEqualsString.Test_NULL_NULL
AS
BEGIN
    EXEC tSQLt.AssertEqualsString NULL, NULL;
END;
GO

CREATE PROCEDURE Test_AssertEqualsString.Test_Hello_Hallo
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsString failed. Expected:<hello>. Actual:<hallo>.';

    EXEC tSQLt.AssertEqualsString 'hello', 'hallo';
END;
GO

CREATE PROCEDURE Test_AssertEqualsString.Test_ErrorMessage
AS
BEGIN
    EXEC tSQLt.ExpectException 'Error message. tSQLt.AssertEqualsString failed. Expected:<hello>. Actual:<hallo>.';

    EXEC tSQLt.AssertEqualsString 'hello', 'hallo', 'Error message.';
END;
GO

CREATE PROCEDURE Test_AssertEqualsString.Test_Hello_NULL
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertEqualsString failed. Expected:<hello>. Actual:<(null)>.';

    EXEC tSQLt.AssertEqualsString 'hello', NULL;
END;
GO