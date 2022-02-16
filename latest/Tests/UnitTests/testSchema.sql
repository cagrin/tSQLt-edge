CREATE SCHEMA testSchema;
GO

CREATE PROCEDURE testSchema.test1
AS
BEGIN
    SET NOCOUNT ON;
--- Arrange
--- Act

--- Assert
	IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'tSQLt')
    BEGIN
        RAISERROR('testSchema.test1 - failed!', 16, 10);
    END
    ELSE
    BEGIN
        PRINT 'testSchema.test1 - passed'
    END
END;
GO