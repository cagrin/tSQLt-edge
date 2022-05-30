CREATE SCHEMA Test_AssertStringIn;
GO

CREATE PROCEDURE Test_AssertStringIn.Test_Empty_Null
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertStringIn failed. String:<(null)> is not in <(null)>.'

    DECLARE @Expected tSQLt.AssertStringTable;

    DECLARE @Actual NVARCHAR(MAX);
    EXEC tSQLt.AssertStringIn @Expected, @Actual;
END;
GO

CREATE PROCEDURE Test_AssertStringIn.Test_Null_Null
AS
BEGIN
    DECLARE @Expected tSQLt.AssertStringTable;
    INSERT INTO @Expected ([value]) VALUES (NULL);

    DECLARE @Actual NVARCHAR(MAX);
    EXEC tSQLt.AssertStringIn @Expected, @Actual;
END;
GO

CREATE PROCEDURE Test_AssertStringIn.Test_Empty_Hello
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertStringIn failed. String:<Hello> is not in <(null)>.'

    DECLARE @Expected tSQLt.AssertStringTable;

    DECLARE @Actual NVARCHAR(MAX) = 'Hello';
    EXEC tSQLt.AssertStringIn @Expected, @Actual;
END;
GO

CREATE PROCEDURE Test_AssertStringIn.Test_Hello_Hallo
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertStringIn failed. String:<Hallo> is not in <Hello, World>.'

    DECLARE @Expected tSQLt.AssertStringTable;
    INSERT INTO @Expected ([value]) VALUES ('Hello'), ('World');

    DECLARE @Actual NVARCHAR(MAX) = 'Hallo';
    EXEC tSQLt.AssertStringIn @Expected, @Actual;
END;
GO

CREATE PROCEDURE Test_AssertStringIn.Test_Hello_Hello
AS
BEGIN
    DECLARE @Expected tSQLt.AssertStringTable;
    INSERT INTO @Expected ([value]) VALUES ('Hello'), ('World');

    DECLARE @Actual NVARCHAR(MAX) = 'Hello';
    EXEC tSQLt.AssertStringIn @Expected, @Actual;
END;
GO