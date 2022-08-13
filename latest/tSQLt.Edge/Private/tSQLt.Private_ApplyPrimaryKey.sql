CREATE PROCEDURE tSQLt.Private_ApplyPrimaryKey
    @ObjectName NVARCHAR(MAX),
    @ConstraintId INT
AS
BEGIN
    DECLARE @System_IndexColumns tSQLt.System_IndexColumnsType
    INSERT INTO @System_IndexColumns
    EXEC tSQLt.System_IndexColumns

    DECLARE @Result TABLE
    (
        [_id_] INT IDENTITY(1,1),
        [definition] NVARCHAR(MAX),
        [object_id] [int] NOT NULL,
        [schema_id] [int] NOT NULL,
        [table_name] [sysname] NOT NULL,
        [index_name] [sysname] NULL,
        [column_name] [sysname] NULL,
        [key_ordinal] [tinyint] NOT NULL,
        [is_descending_key] [bit] NULL,
        [type_desc] [nvarchar](60) NULL,
        [column_id] [int] NOT NULL,
        [user_type_id] [int] NOT NULL,
        [max_length] [smallint] NOT NULL,
        [precision] [tinyint] NOT NULL,
        [scale] [tinyint] NOT NULL,
        [collation_name] [sysname] NULL
    )

    INSERT INTO @Result
    (
        [object_id],
        [schema_id],
        [table_name],
        [index_name],
        [column_name],
        [key_ordinal],
        [is_descending_key],
        [type_desc],
        [column_id],
        [user_type_id],
        [max_length],
        [precision],
        [scale],
        [collation_name]
    )
    SELECT
        [object_id],
        [schema_id],
        [table_name],
        [index_name],
        [column_name],
        [key_ordinal],
        [is_descending_key],
        [type_desc],
        [column_id],
        [user_type_id],
        [max_length],
        [precision],
        [scale],
        [collation_name]
    FROM @System_IndexColumns
    WHERE [schema_id] = SCHEMA_ID(OBJECT_SCHEMA_NAME(OBJECT_ID(@ObjectName)))
    AND [index_name] = OBJECT_NAME(@ConstraintId)
    AND [is_primary_key] = 1

    DECLARE
        @_i_ INT = 1,
        @_m_ INT = (SELECT COUNT(1) FROM @Result),
        @user_type_id [int],
        @max_length [smallint],
        @precision [tinyint],
        @scale [tinyint],
        @collation_name [sysname]

    WHILE (@_i_ <= @_m_)
    BEGIN
        SELECT
            @user_type_id = [user_type_id],
            @max_length = [max_length],
            @precision = [precision],
            @scale = [scale],
            @collation_name = [collation_name]
        FROM @Result
        WHERE _id_ = @_i_

        DECLARE @Type NVARCHAR(MAX)
        EXEC tSQLt.Private_GetType @Type OUTPUT, @user_type_id, @max_length, @precision, @scale, @collation_name

        UPDATE @Result
        SET definition = @Type
        WHERE _id_ = @_i_

        SET @_i_ = @_i_ + 1
    END

    DECLARE @AlterPrimaryColumns NVARCHAR(MAX);
    SELECT
        @AlterPrimaryColumns = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                'ALTER TABLE', @ObjectName, 'ALTER COLUMN', QUOTENAME([column_name]),
                definition,
                'NOT NULL'
            ),
            ' '
        )
    FROM @Result

    DECLARE @ParentName NVARCHAR(MAX), @ConstraintName NVARCHAR(MAX), @ConstraintDefinition NVARCHAR(MAX);
    SELECT
        @ParentName = CONCAT(QUOTENAME(SCHEMA_NAME([schema_id])), '.', QUOTENAME([table_name])),
        @ConstraintName = QUOTENAME([index_name]),
        @ConstraintDefinition = CONCAT
        (
            [type_desc],
            ' (',
            STRING_AGG
            (
                CONCAT_WS
                (
                    ' ',
                    QUOTENAME([column_name]),
                    CASE WHEN [is_descending_key] = 1 THEN 'DESC' ELSE 'ASC' END
                ),
                ', '
            ),
            ')'
        )
    FROM @Result
    GROUP BY [schema_id], [table_name], [index_name], [type_desc]

    DECLARE @CreatePrimaryKey NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'ALTER TABLE', @ParentName, 'DROP CONSTRAINT', @ConstraintName,
        'ALTER TABLE', @ObjectName, 'ADD CONSTRAINT',  @ConstraintName, 'PRIMARY KEY', @ConstraintDefinition
    )

    EXEC (@AlterPrimaryColumns);
    EXEC (@CreatePrimaryKey);
END;
GO