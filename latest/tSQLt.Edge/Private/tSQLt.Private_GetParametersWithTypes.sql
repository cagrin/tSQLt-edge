CREATE PROCEDURE tSQLt.Private_GetParametersWithTypes
    @ParametersWithTypes NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX),
    @DefaultNulls BIT = NULL,
    @Scalar BIT = NULL
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectName

    DECLARE @Result TABLE
    (
        [_id_] INT IDENTITY(1,1),
        [definition] NVARCHAR(MAX),
        [name] [sysname] NULL,
        [parameter_id] [int] NOT NULL,
        [user_type_id] [int] NOT NULL,
        [max_length] [smallint] NOT NULL,
        [precision] [tinyint] NOT NULL,
        [scale] [tinyint] NOT NULL,
        [is_output] [bit] NOT NULL,
        [is_readonly] [bit] NOT NULL
    )

    INSERT INTO @Result
    (
        [name],
        [parameter_id],
        [user_type_id],
        [max_length],
        [precision],
        [scale],
        [is_output],
        [is_readonly]
    )
    SELECT
        [name],
        [parameter_id],
        [user_type_id],
        [max_length],
        [precision],
        [scale],
        [is_output],
        [is_readonly]
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
        EXEC tSQLt.Private_GetType @ObjectName, @Type OUTPUT, @user_type_id, @max_length, @precision, @scale

        UPDATE @Result
        SET definition = @Type
        WHERE _id_ = @_i_

        SET @_i_ = @_i_ + 1
    END

    SELECT
        @ParametersWithTypes = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                name,
                definition,
                CASE WHEN @DefaultNulls = 1 THEN CASE WHEN is_readonly = 1 THEN 'READONLY' ELSE '= NULL' END END,
                CASE WHEN is_output = 1 THEN 'OUTPUT' ELSE NULL END
            ),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM @Result
    WHERE (@Scalar = 1 AND parameter_id > 0) OR ISNULL(@Scalar, 0) = 0
END;
GO