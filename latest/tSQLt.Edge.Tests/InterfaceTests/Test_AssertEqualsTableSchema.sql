CREATE SCHEMA Test_AssertEqualsTableSchema;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_TwoIdenticalTables
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 INT);');
    EXEC ('CREATE TABLE dbo.TestTable2 (Column1 INT);');

    EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_DifferentColumnNames
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 INT);');
    EXEC ('CREATE TABLE dbo.TestTable2 (Column2 INT);');

    DECLARE @Expected NVARCHAR(MAX), @Actual NVARCHAR(MAX);
    BEGIN TRY
        EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertEqualsTableSchema failed. Expected:<Column1 int NULL>. Actual:<Column2 int NULL>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
END;
GO

CREATE PROCEDURE Test_AssertEqualsTableSchema.Test_DifferentColumnNullable
AS
BEGIN
    EXEC ('CREATE TABLE dbo.TestTable1 (Column1 INT);');
    EXEC ('CREATE TABLE dbo.TestTable2 (Column1 INT NOT NULL);');

    DECLARE @Expected NVARCHAR(MAX), @Actual NVARCHAR(MAX);
    BEGIN TRY
        EXEC tSQLt.AssertEqualsTableSchema 'dbo.TestTable1', 'dbo.TestTable2';
    END TRY
    BEGIN CATCH
        SELECT @Expected = 'tSQLt.AssertEqualsTableSchema failed. Expected:<Column1 int NULL>. Actual:<Column1 int NOT NULL>.', @Actual = ERROR_MESSAGE();
        EXEC tSQLt.AssertEqualsString @Expected, @Actual;
    END CATCH
END;
GO