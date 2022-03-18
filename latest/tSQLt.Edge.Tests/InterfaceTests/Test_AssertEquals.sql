CREATE SCHEMA Test_AssertEquals;
GO

CREATE PROCEDURE Test_AssertEquals.Test_Hello_Hello
AS
BEGIN
    EXEC tSQLt.AssertEquals 'hello', 'hello';
END;
GO

CREATE PROCEDURE Test_AssertEquals.Test_NULL_NULL
AS
BEGIN
    EXEC tSQLt.AssertEquals NULL, NULL;
END;
GO

CREATE PROCEDURE Test_AssertEquals.Test_Hello_Hallo
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertEquals failed. Expected:<hello>. Actual:<hallo>.';

    EXEC tSQLt.AssertEquals 'hello', 'hallo';
END;
GO

CREATE PROCEDURE Test_AssertEquals.Test_Hello_NULL
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertEquals failed. Expected:<hello>. Actual:<(null)>.';

    EXEC tSQLt.AssertEquals 'hello', NULL;
END;
GO

CREATE PROCEDURE Test_AssertEquals.Test_5_5
AS
BEGIN
    EXEC tSQLt.AssertEquals 5, 5;
END;
GO

CREATE PROCEDURE Test_AssertEquals.Test_Pi_Pi
AS
BEGIN
    EXEC tSQLt.AssertEquals 3.14, 3.14;
END;
GO

CREATE PROCEDURE Test_AssertEquals.Test_5_6
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertEquals failed. Expected:<5>. Actual:<6>.';

    EXEC tSQLt.AssertEquals 5, 6;
END;
GO

CREATE PROCEDURE Test_AssertEquals.Test_Pi_Pi1
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertEquals failed. Expected:<3.14>. Actual:<3.141>.';

    EXEC tSQLt.AssertEquals 3.14, 3.141;
END;
GO