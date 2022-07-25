CREATE PROCEDURE tSQLt.Private_GetColumns
    @Columns NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    DECLARE
        @object_id [int],
        @name [sysname],
        @column_id [int],
        @user_type_id [int],
        @max_length [smallint],
        @precision [tinyint],
        @scale [tinyint],
        @collation_name [sysname],
        @is_nullable [bit],
        @is_identity [bit],
        @is_computed [bit],
        @default_object_id [int]

    DECLARE @System_Columns tSQLt.System_ColumnsType
    INSERT INTO @System_Columns
    EXEC tSQLt.System_Columns @ObjectName

    DECLARE @result TABLE
    (
        [_id_] INT IDENTITY(1,1),
        [definition] NVARCHAR(MAX),
        [column_id] [int],
        [name] [sysname]
    )

    INSERT INTO @result (column_id, name)
    SELECT column_id, name
    FROM @System_Columns
    ORDER BY column_id

    DECLARE
        @_i_ INT = 1,
        @_m_ INT = (SELECT COUNT(1) FROM @result)

    WHILE (@_i_ <= @_m_)
    BEGIN
        SELECT
            @object_id = [object_id],
            @name = [name],
            @column_id = [column_id],
            @user_type_id = [user_type_id],
            @max_length = [max_length],
            @precision = [precision],
            @scale = [scale],
            @collation_name = [collation_name],
            @is_nullable = [is_nullable],
            @is_identity = [is_identity],
            @is_computed = [is_computed],
            @default_object_id = [default_object_id]
        FROM @System_Columns
        WHERE column_id = (SELECT column_id FROM @result WHERE _id_ = @_i_)

        DECLARE @ComputedColumn NVARCHAR(MAX) = tSQLt.Private_GetComputedColumn(@ObjectName, @column_id)
        DECLARE @Type NVARCHAR(MAX) = tSQLt.Private_GetType(@user_type_id, @max_length, @precision, @scale, @collation_name)
        DECLARE @IdentityColumn NVARCHAR(MAX) = tSQLt.Private_GetIdentityColumn(@ObjectName, @column_id)
        DECLARE @DefaultConstraints NVARCHAR(MAX) = tSQLt.Private_GetDefaultConstraints(@ObjectName, @column_id)

        UPDATE @result
        SET definition =
            CASE @is_computed
                WHEN 1 THEN @ComputedColumn
                ELSE CONCAT_WS
                (
                    ' ', @Type,
                    CASE @is_identity WHEN 1 THEN @IdentityColumn END,
                    CASE WHEN @default_object_id > 0 THEN @DefaultConstraints ELSE
                    CASE @is_nullable WHEN 1 THEN 'NULL' ELSE 'NOT NULL' END END
                )
            END
        WHERE _id_ = @_i_

        SET @_i_ = @_i_ + 1
    END

    SELECT
        @Columns = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                QUOTENAME(name),
                definition
            ),
            ', '
        ) WITHIN GROUP (ORDER BY column_id)
    FROM @result
END;
GO