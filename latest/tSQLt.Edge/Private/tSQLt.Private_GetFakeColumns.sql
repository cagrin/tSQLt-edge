CREATE PROCEDURE tSQLt.Private_GetFakeColumns
    @FakeColumns NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX),
    @Identity BIT,
    @ComputedColumns BIT,
    @Defaults BIT,
    @NotNulls BIT
AS
BEGIN
    DECLARE @System_Columns tSQLt.System_ColumnsType
    INSERT INTO @System_Columns
    EXEC tSQLt.System_Columns @ObjectName

    DECLARE @Result TABLE
    (
        [_id_] INT IDENTITY(1,1),
        [definition] NVARCHAR(MAX),
        [object_id] [int] NOT NULL,
        [name] [sysname] NULL,
        [column_id] [int] NOT NULL,
        [user_type_id] [int] NOT NULL,
        [max_length] [smallint] NOT NULL,
        [precision] [tinyint] NOT NULL,
        [scale] [tinyint] NOT NULL,
        [collation_name] [sysname] NULL,
        [is_nullable] [bit] NULL,
        [is_identity] [bit] NOT NULL,
        [is_computed] [bit] NOT NULL,
        [default_object_id] [int] NOT NULL
    )

    INSERT INTO @Result
    (
        [object_id],
        [name],
        [column_id],
        [user_type_id],
        [max_length],
        [precision],
        [scale],
        [collation_name],
        [is_nullable],
        [is_identity],
        [is_computed],
        [default_object_id]
    )
    SELECT
        [object_id],
        [name],
        [column_id],
        [user_type_id],
        [max_length],
        [precision],
        [scale],
        [collation_name],
        [is_nullable],
        [is_identity],
        [is_computed],
        [default_object_id]
    FROM @System_Columns
    ORDER BY column_id

    DECLARE
        @_i_ INT = 1,
        @_m_ INT = (SELECT COUNT(1) FROM @Result),
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
        FROM @Result
        WHERE _id_ = @_i_

        DECLARE
            @Type NVARCHAR(MAX),
            @ComputedColumn NVARCHAR(MAX),
            @IdentityColumn NVARCHAR(MAX),
            @DefaultConstraints NVARCHAR(MAX)

        EXEC tSQLt.Private_GetType @Type OUTPUT, @user_type_id, @max_length, @precision, @scale, @collation_name
        IF @ComputedColumns = 1 AND @is_computed = 1
        BEGIN
            EXEC tSQLt.Private_GetComputedColumn @ComputedColumn OUTPUT, @ObjectName, @column_id
        END
        IF @Identity = 1 AND @is_identity = 1
        BEGIN
            EXEC tSQLt.Private_GetIdentityColumn @IdentityColumn OUTPUT, @ObjectName, @column_id
        END
        IF @Defaults = 1 AND @default_object_id > 0
        BEGIN
            EXEC tSQLt.Private_GetDefaultConstraints @DefaultConstraints OUTPUT, @ObjectName, @column_id
        END

        UPDATE @Result
        SET definition =
            CASE
                WHEN @ComputedColumns = 1 AND @is_computed = 1 THEN @ComputedColumn
                ELSE CONCAT_WS
                (
                    ' ', @Type,
                    CASE WHEN @Identity = 1 AND @is_identity = 1 THEN @IdentityColumn END,
                    CASE WHEN @Defaults = 1 AND @default_object_id > 0 THEN @DefaultConstraints ELSE
                    CASE WHEN @NotNulls = 1 AND @is_nullable = 0 THEN 'NOT NULL' END END
                )
            END
        WHERE _id_ = @_i_

        SET @_i_ = @_i_ + 1
    END

    SELECT
        @FakeColumns = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                QUOTENAME(name),
                definition
            ),
            ', '
        ) WITHIN GROUP (ORDER BY column_id)
    FROM @Result
END;
GO