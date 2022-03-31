CREATE PROCEDURE tSQLt.Private_ProcessTableName
    @TableName NVARCHAR(MAX) OUTPUT
AS
BEGIN
    EXEC tSQLt.AssertObjectExists @TableName;

    DECLARE @BaseObjectName NVARCHAR(MAX) =
    (
        SELECT base_object_name
        FROM sys.synonyms
        WHERE object_id = OBJECT_ID(@TableName)
    )

    IF (@BaseObjectName IS NOT NULL)
    BEGIN
        IF (COALESCE(OBJECT_ID(@BaseObjectName, 'U'), OBJECT_ID(@BaseObjectName, 'V')) IS NULL)
        BEGIN
            EXEC tSQLt.Fail 'Cannot process synonym', @TableName, 'as it is pointing to', @BaseObjectName, 'which is not a table or view.';
        END;

        SET @TableName = @BaseObjectName;
    END
END;
GO