CREATE PROCEDURE tSQLt.Internal_ApplyConstraint
    @TableName NVARCHAR(MAX),
    @ConstraintName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL, --parameter preserved for backward compatibility. Do not use. Will be removed soon.
    @NoCascade BIT = 0
AS
BEGIN
    DECLARE @ObjectName NVARCHAR(MAX) = @TableName;

    IF @SchemaName IS NOT NULL
        SET @ObjectName = CONCAT(@SchemaName, '.', @TableName)

    EXEC tSQLt.AssertObjectExists @ObjectName;

    DECLARE @ConstraintId INT, @ConstraintType CHAR(2);
    SELECT
        @ConstraintId = [object_id],
        @ConstraintType = [type]
    FROM tSQLt.System_objects()
    WHERE [schema_id] = SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName)))
    AND ([name] = @ConstraintName OR QUOTENAME([name]) = @ConstraintName)

    IF @ConstraintType = 'C'
    BEGIN
        EXEC tSQLt.Private_ApplyCheckConstraint @Objectname, @ConstraintId;
    END
    ELSE IF @ConstraintType = 'F'
    BEGIN
        EXEC tSQLt.Private_ApplyForeignKey @Objectname, @ConstraintId, @NoCascade;
    END
    ELSE IF @ConstraintType = 'PK'
    BEGIN
        EXEC tSQLt.Private_ApplyPrimaryKey @Objectname, @ConstraintId;
    END
    ELSE IF @ConstraintType = 'UQ'
    BEGIN
        EXEC tSQLt.Private_ApplyUniqueConstraint @Objectname, @ConstraintId;
    END
    ELSE
    BEGIN
        DECLARE @Failed NVARCHAR(MAX) = CONCAT_WS
        (
            ' ',
            'tSQLt.ApplyConstraint failed.',
            CONCAT('Constraint:<', @ConstraintName, '> on table <', @ObjectName,'> does not exist.')
        );
        EXEC tSQLt.Fail @Failed;
    END
END;
GO