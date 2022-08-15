CREATE PROCEDURE tSQLt.Private_GetQuotedObjectName
    @QuotedObjectName NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    SET @QuotedObjectName = @ObjectName;
    IF (OBJECT_ID(@ObjectName) IS NOT NULL)
    BEGIN
        SET @QuotedObjectName = CONCAT
        (
            CASE WHEN PARSENAME(@ObjectName, 3) IS NOT NULL THEN CONCAT(QUOTENAME(PARSENAME(@ObjectName, 3)), '.') END,
            QUOTENAME(PARSENAME(@ObjectName, 2)), '.',
            QUOTENAME(PARSENAME(@ObjectName, 1))
        );
    END
    ELSE IF (OBJECT_ID(CONCAT('tempdb..', @ObjectName)) IS NOT NULL AND SUBSTRING(@ObjectName, 1, 1) = '#')
    BEGIN
        SET @QuotedObjectName = CONCAT('[#', SUBSTRING(@ObjectName, 2, LEN(@ObjectName) - 1), ']');
    END
END;
GO