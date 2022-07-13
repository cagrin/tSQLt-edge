CREATE PROCEDURE tSQLt.Internal_ApplyConstraint
    @TableName NVARCHAR(MAX),
    @ConstraintName NVARCHAR(MAX),
    @SchemaName NVARCHAR(MAX) = NULL,
    @NoCascade BIT = 0
AS
BEGIN
    DECLARE @ObjectName NVARCHAR(MAX), @ConstraintId INT, @ConstraintType CHAR(2);
    EXEC tSQLt.Private_ProcessConstraintName @ObjectName OUTPUT, @ConstraintId OUTPUT, @ConstraintType OUTPUT, @TableName, @ConstraintName, @SchemaName;

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