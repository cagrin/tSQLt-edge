CREATE SCHEMA Test_AssertNotEquals;
GO

CREATE PROCEDURE Test_AssertNotEquals.Test_Hello_Hallo
AS
BEGIN
    EXEC tSQLt.AssertNotEquals 'hello', 'hallo';
END;
GO

CREATE PROCEDURE Test_AssertNotEquals.Test_Hello_NULL
AS
BEGIN
    EXEC tSQLt.AssertNotEquals 'hello', NULL;
END;
GO

CREATE PROCEDURE Test_AssertNotEquals.Test_Hello_Hello
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertNotEquals failed. Expected any value except:<hello>. Actual:<hello>.';

    EXEC tSQLt.AssertNotEquals 'hello', 'hello';
END;
GO

CREATE PROCEDURE Test_AssertNotEquals.Test_NULL_NULL
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertNotEquals failed. Expected any value except:<(null)>. Actual:<(null)>.';

    EXEC tSQLt.AssertNotEquals NULL, NULL;
END;
GO

CREATE PROCEDURE Test_AssertNotEquals.Test_5_6
AS
BEGIN
    EXEC tSQLt.AssertNotEquals 5, 6;
END;
GO

CREATE PROCEDURE Test_AssertNotEquals.Test_Pi_Pi1
AS
BEGIN
    EXEC tSQLt.AssertNotEquals 3.14, 3.141;
END;
GO

CREATE PROCEDURE Test_AssertNotEquals.Test_5_5
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertNotEquals failed. Expected any value except:<5>. Actual:<5>.';

    EXEC tSQLt.AssertNotEquals 5, 5;
END;
GO

CREATE PROCEDURE Test_AssertNotEquals.Test_Pi_Pi
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertNotEquals failed. Expected any value except:<3.14>. Actual:<3.14>.';

    EXEC tSQLt.AssertNotEquals 3.14, 3.14;
END;
GO