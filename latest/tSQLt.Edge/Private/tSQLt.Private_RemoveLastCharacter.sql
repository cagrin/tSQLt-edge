CREATE PROCEDURE tSQLt.Private_RemoveLastCharacter
    @String NVARCHAR(MAX) OUTPUT,
    @Character NCHAR(1)
AS
BEGIN
    DECLARE @RandomSuffix NVARCHAR(MAX) = NEWID()
    SET @String = CONCAT(RTRIM(@String), @RandomSuffix)
    SET @String = REPLACE(@String, CONCAT(@Character, @RandomSuffix), '')
    SET @String = REPLACE(@String, @RandomSuffix, '')
END;
GO