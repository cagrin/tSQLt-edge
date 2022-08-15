CREATE PROCEDURE tSQLt.Private_GetSpyProcedureLogSelect
    @SpyProcedureLogSelect NVARCHAR(MAX) OUTPUT,
    @ObjectName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @System_Parameters tSQLt.System_ParametersType
    INSERT INTO @System_Parameters
    EXEC tSQLt.System_Parameters @ObjectName

    DECLARE @Result TABLE
    (
        [_id_] INT IDENTITY(1,1),
        [definition] NVARCHAR(MAX),
        [is_table_type] BIT,
        [name] [sysname] NULL,
        [parameter_id] [int] NOT NULL,
        [user_type_id] [int] NOT NULL,
        [is_output] [bit] NOT NULL
    )

    INSERT INTO @Result
    (
        [name],
        [parameter_id],
        [user_type_id],
        [is_output]
    )
    SELECT
        [name],
        [parameter_id],
        [user_type_id],
        [is_output]
    FROM @System_Parameters
    ORDER BY parameter_id

    DECLARE
        @_i_ INT = 1,
        @_m_ INT = (SELECT COUNT(1) FROM @Result),
        @user_type_id [int]

    WHILE (@_i_ <= @_m_)
    BEGIN
        SELECT
            @user_type_id = [user_type_id]
        FROM @Result
        WHERE _id_ = @_i_

        DECLARE @IsTableType NVARCHAR(MAX)
        DECLARE @Types tSQLt.System_TypesType
        INSERT INTO @Types
        EXEC tSQLt.System_Types @user_type_id
        SELECT @IsTableType = is_table_type FROM @Types

        UPDATE @Result
        SET is_table_type = @IsTableType
        WHERE _id_ = @_i_

        SET @_i_ = @_i_ + 1
    END

    SELECT
        @SpyProcedureLogSelect = STRING_AGG
        (
            CONCAT_WS
            (
                ' ',
                CASE
                    WHEN is_table_type = 1 THEN CONCAT('(SELECT * FROM ', name, ' FOR XML PATH(''row''),TYPE,ROOT(''', REPLACE(name, '@', ''), '''))')
                    ELSE name
                END,
                CASE WHEN is_output = 1 THEN 'OUTPUT' ELSE NULL END
            ),
            ', '
        ) WITHIN GROUP (ORDER BY parameter_id)
    FROM @Result
END;
GO