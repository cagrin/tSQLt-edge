CREATE PROCEDURE tSQLt.Private_GetSpyProcedureLogColumns
    @SpyProcedureLogColumns NVARCHAR(MAX) OUTPUT,
    @ObjectId INT
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectId

    DECLARE @Result TABLE
    (
        [_id_] INT IDENTITY(1,1),
        [definition] NVARCHAR(MAX),
        [is_table_type] BIT,
        [name] [sysname] NULL,
        [parameter_id] [int] NOT NULL,
        [user_type_id] [int] NOT NULL,
        [max_length] [smallint] NOT NULL,
        [precision] [tinyint] NOT NULL,
        [scale] [tinyint] NOT NULL
    )

    INSERT INTO @Result
    (
        [name],
        [parameter_id],
        [user_type_id],
        [max_length],
        [precision],
        [scale]
    )
    SELECT
        [name],
        [parameter_id],
        [user_type_id],
        [max_length],
        [precision],
        [scale]
    FROM @System_Parameters
    ORDER BY parameter_id

    DECLARE
        @_i_ INT = 1,
        @_m_ INT = (SELECT COUNT(1) FROM @Result),
        @user_type_id [int],
        @max_length [smallint],
        @precision [tinyint],
        @scale [tinyint]

    WHILE (@_i_ <= @_m_)
    BEGIN
        SELECT
            @user_type_id = [user_type_id],
            @max_length = [max_length],
            @precision = [precision],
            @scale = [scale]
        FROM @Result
        WHERE _id_ = @_i_

        DECLARE @Type NVARCHAR(MAX)
        EXEC tSQLt.Private_GetType @Type OUTPUT, @user_type_id, @max_length, @precision, @scale

        DECLARE @IsTableType NVARCHAR(MAX)
        DECLARE @Types tSQLt.System_TypesType
        INSERT INTO @Types
        EXEC tSQLt.System_Types @user_type_id
        SELECT @IsTableType = is_table_type FROM @Types

        UPDATE @Result
        SET
            definition = @Type,
            is_table_type = @IsTableType
        WHERE _id_ = @_i_

        SET @_i_ = @_i_ + 1
    END

    SELECT
        @SpyProcedureLogColumns = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                REPLACE(name, '@', ''),
                CASE
                    WHEN is_table_type = 1 THEN 'xml'
                    ELSE definition
                END,
                'NULL'
            ),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM @Result
END;
GO