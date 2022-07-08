CREATE PROCEDURE tSQLt.Private_ProcessTableName
    @TableName NVARCHAR(MAX) OUTPUT,
    @SchemaName NVARCHAR(MAX) = NULL
AS
BEGIN
    IF @SchemaName IS NOT NULL
    BEGIN
        IF OBJECT_ID(CONCAT(@TableName, '.', @SchemaName)) IS NOT NULL
            SET @TableName = CONCAT(@TableName, '.', @SchemaName)
        ELSE
            SET @TableName = CONCAT(@SchemaName, '.', @TableName)
    END

    EXEC tSQLt.AssertObjectExists @TableName;

    DECLARE @BaseObjectName NVARCHAR(MAX) =
    (
        SELECT base_object_name
        FROM tSQLt.System_Synonyms()
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