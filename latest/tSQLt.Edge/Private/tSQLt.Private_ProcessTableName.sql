CREATE PROCEDURE tSQLt.Private_ProcessTableName
    @TableName NVARCHAR(MAX) OUTPUT,
    @SchemaName NVARCHAR(MAX) = NULL
AS
BEGIN
    IF @SchemaName IS NOT NULL
    BEGIN
        SELECT
            @TableName = CONCAT(ISNULL(CleanSchemaName, @SchemaName), '.', ISNULL(CleanTableName, @TableName))
        FROM tSQLt.Private_ResolveFakeTableNamesForBackwardCompatibility (@TableName, @SchemaName)
    END

    EXEC tSQLt.AssertObjectExists @TableName;

    IF OBJECT_ID(@TableName, 'SN') IS NOT NULL
    BEGIN
        DECLARE @System_Synonyms tSQLt.System_SynonymsType
        INSERT INTO @System_Synonyms
        EXEC tSQLt.System_Synonyms @TableName

        DECLARE @BaseObjectName NVARCHAR(MAX) =
        (
            SELECT base_object_name
            FROM @System_Synonyms
        )

        IF (@BaseObjectName IS NOT NULL)
        BEGIN
            IF (COALESCE(OBJECT_ID(@BaseObjectName, 'U'), OBJECT_ID(@BaseObjectName, 'V')) IS NULL)
            BEGIN
                EXEC tSQLt.Fail 'Cannot process synonym', @TableName, 'as it is pointing to', @BaseObjectName, 'which is not a table or view.';
            END;

            SET @TableName = @BaseObjectName;
        END
    END
END;
GO