CREATE FUNCTION tSQLt.Private_GetQuotedObjectName (@ObjectName NVARCHAR(MAX))
RETURNS NVARCHAR(MAX) AS
BEGIN
    DECLARE @QuotedObjectName NVARCHAR(MAX) = @ObjectName;
    IF (OBJECT_ID(@ObjectName) IS NOT NULL)
    BEGIN
        SET @QuotedObjectName = CONCAT(QUOTENAME(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName))), '.', QUOTENAME(OBJECT_NAME(OBJECT_ID(@ObjectName))));
    END
    ELSE IF (OBJECT_ID(CONCAT('tempdb..', @ObjectName)) IS NOT NULL AND SUBSTRING(@ObjectName, 1, 1) = '#')
    BEGIN
        SET @QuotedObjectName = CONCAT('[#', SUBSTRING(@ObjectName, 2, LEN(@ObjectName) - 1), ']');
    END
    RETURN @QuotedObjectName;
END;
GO