CREATE SCHEMA Test_RunAll;
GO

CREATE PROCEDURE Test_RunAll.Test_Interfaces
AS
BEGIN
    DECLARE
        @schema_id [int],
        @object_id [int],
        @name [sysname]

    DECLARE @System_Interfaces tSQLt.System_InterfacesType
    INSERT INTO @System_Interfaces
    EXEC tSQLt.System_Interfaces

    DECLARE @Result TABLE
    (
        [_id_] INT IDENTITY(1,1),
        [definition] NVARCHAR(MAX),
        [schema_id] [int],
        [object_id] [int],
        [name] [sysname]
    )

    INSERT INTO @Result (schema_id, object_id, name)
    SELECT schema_id, object_id, name
    FROM @System_Interfaces
    ORDER BY name

    DECLARE
        @_i_ INT = 1,
        @_m_ INT = (SELECT COUNT(1) FROM @Result)

    WHILE (@_i_ <= @_m_)
    BEGIN
        SELECT
            @schema_id = [schema_id],
            @object_id = [object_id],
            @name = [name]
        FROM @System_Interfaces
        WHERE object_id = (SELECT object_id FROM @Result WHERE _id_ = @_i_)

        DECLARE @TestName NVARCHAR(MAX) = CONCAT(QUOTENAME(SCHEMA_NAME(@schema_id)), '.', QUOTENAME(@name))
        DECLARE @Parameters NVARCHAR(MAX);
        EXEC tSQLt.Private_GetParameters @Parameters OUTPUT, @TestName;

        UPDATE @Result
        SET definition = @Parameters
        WHERE _id_ = @_i_

        SET @_i_ = @_i_ + 1
    END

    DECLARE @Actual NVARCHAR(MAX) =
    (
        SELECT
            STRING_AGG
            (
                CONCAT
                (
                    'EXEC ',
                    QUOTENAME(SCHEMA_NAME(schema_id)),
                    '.',
                    QUOTENAME(name),
                    ' ',
                    definition,
                    ';'
                ),
                ' '
            ) WITHIN GROUP (ORDER BY name)
        FROM @Result
    );

    DECLARE @Expected NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        'EXEC [tSQLt].[ApplyConstraint] @TableName, @ConstraintName, @SchemaName, @NoCascade;',
        'EXEC [tSQLt].[ApplyIndex] @TableName, @IndexName;',
        'EXEC [tSQLt].[ApplyTrigger] @TableName, @TriggerName;',
        'EXEC [tSQLt].[AssertEmptyTable] @TableName, @Message;',
        'EXEC [tSQLt].[AssertEquals] @Expected, @Actual, @Message;',
        'EXEC [tSQLt].[AssertEqualsString] @Expected, @Actual, @Message;',
        'EXEC [tSQLt].[AssertEqualsTable] @Expected, @Actual, @Message, @FailMsg;',
        'EXEC [tSQLt].[AssertEqualsTableSchema] @Expected, @Actual, @Message;',
        'EXEC [tSQLt].[AssertLike] @ExpectedPattern, @Actual, @Message;',
        'EXEC [tSQLt].[AssertNotEquals] @Expected, @Actual, @Message;',
        'EXEC [tSQLt].[AssertNotEqualsString] @Expected, @Actual, @Message;',
        'EXEC [tSQLt].[AssertObjectDoesNotExist] @ObjectName, @Message;',
        'EXEC [tSQLt].[AssertObjectExists] @ObjectName, @Message;',
        'EXEC [tSQLt].[AssertResultSetsHaveSameMetaData] @expectedCommand, @actualCommand;',
        'EXEC [tSQLt].[AssertStringIn] @Expected, @Actual, @Message;',
        'EXEC [tSQLt].[DropClass] @ClassName;',
        'EXEC [tSQLt].[ExpectException] @ExpectedMessage, @ExpectedSeverity, @ExpectedState, @Message, @ExpectedMessagePattern, @ExpectedErrorNumber;',
        'EXEC [tSQLt].[ExpectNoException] @Message;',
        'EXEC [tSQLt].[Fail] @Message0, @Message1, @Message2, @Message3, @Message4, @Message5, @Message6, @Message7, @Message8, @Message9;',
        'EXEC [tSQLt].[FakeFunction] @FunctionName, @FakeFunctionName, @FakeDataSource;',
        'EXEC [tSQLt].[FakeTable] @TableName, @SchemaName, @Identity, @ComputedColumns, @Defaults, @NotNulls;',
        'EXEC [tSQLt].[NewTestClass] @ClassName;',
        'EXEC [tSQLt].[RemoveObject] @ObjectName, @NewName OUTPUT, @IfExists;',
        'EXEC [tSQLt].[RemoveObjectIfExists] @ObjectName, @NewName OUTPUT;',
        'EXEC [tSQLt].[RenameClass] @SchemaName, @NewSchemaName;',
        'EXEC [tSQLt].[Run] @TestName, @TestResultFormatter;',
        'EXEC [tSQLt].[SpyProcedure] @ProcedureName, @CommandToExecute, @CallOriginal, @CatchExecutionTimes;',
        'EXEC [tSQLt].[XmlResultFormatter] ;'
    );

    EXEC tSQLt.AssertEqualsString @Expected, @Actual;
END;
GO

CREATE PROCEDURE Test_RunAll.Test_InterfacesWithTypes
AS
BEGIN
    DECLARE
        @schema_id [int],
        @object_id [int],
        @name [sysname]

    DECLARE @System_Interfaces tSQLt.System_InterfacesType
    INSERT INTO @System_Interfaces
    EXEC tSQLt.System_Interfaces

    DECLARE @Result TABLE
    (
        [_id_] INT IDENTITY(1,1),
        [definition] NVARCHAR(MAX),
        [schema_id] [int],
        [object_id] [int],
        [name] [sysname]
    )

    INSERT INTO @Result (schema_id, object_id, name)
    SELECT schema_id, object_id, name
    FROM @System_Interfaces
    ORDER BY name

    DECLARE
        @_i_ INT = 1,
        @_m_ INT = (SELECT COUNT(1) FROM @Result)

    WHILE (@_i_ <= @_m_)
    BEGIN
        SELECT
            @schema_id = [schema_id],
            @object_id = [object_id],
            @name = [name]
        FROM @System_Interfaces
        WHERE object_id = (SELECT object_id FROM @Result WHERE _id_ = @_i_)

        DECLARE @TestName NVARCHAR(MAX) = CONCAT(QUOTENAME(SCHEMA_NAME(@schema_id)), '.', QUOTENAME(@name))
        DECLARE @ParametersWithTypes NVARCHAR(MAX);
        EXEC tSQLt.Private_GetParametersWithTypes @ParametersWithTypes OUTPUT, @TestName;

        UPDATE @Result
        SET definition = @ParametersWithTypes
        WHERE _id_ = @_i_

        SET @_i_ = @_i_ + 1
    END

    DECLARE @Actual NVARCHAR(MAX) =
    (
        SELECT
            STRING_AGG
            (
                CONCAT
                (
                    QUOTENAME(SCHEMA_NAME(schema_id)),
                    '.',
                    QUOTENAME(name),
                    ' ',
                    definition,
                    ';'
                ),
                ' '
            ) WITHIN GROUP (ORDER BY name)
        FROM @Result
    );

    DECLARE @Expected NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        '[tSQLt].[ApplyConstraint] @TableName nvarchar(max), @ConstraintName nvarchar(max), @SchemaName nvarchar(max), @NoCascade bit;',
        '[tSQLt].[ApplyIndex] @TableName nvarchar(max), @IndexName nvarchar(max);',
        '[tSQLt].[ApplyTrigger] @TableName nvarchar(max), @TriggerName nvarchar(max);',
        '[tSQLt].[AssertEmptyTable] @TableName nvarchar(max), @Message nvarchar(max);',
        '[tSQLt].[AssertEquals] @Expected sql_variant, @Actual sql_variant, @Message nvarchar(max);',
        '[tSQLt].[AssertEqualsString] @Expected nvarchar(max), @Actual nvarchar(max), @Message nvarchar(max);',
        '[tSQLt].[AssertEqualsTable] @Expected nvarchar(max), @Actual nvarchar(max), @Message nvarchar(max), @FailMsg nvarchar(max);',
        '[tSQLt].[AssertEqualsTableSchema] @Expected nvarchar(max), @Actual nvarchar(max), @Message nvarchar(max);',
        '[tSQLt].[AssertLike] @ExpectedPattern nvarchar(max), @Actual nvarchar(max), @Message nvarchar(max);',
        '[tSQLt].[AssertNotEquals] @Expected sql_variant, @Actual sql_variant, @Message nvarchar(max);',
        '[tSQLt].[AssertNotEqualsString] @Expected nvarchar(max), @Actual nvarchar(max), @Message nvarchar(max);',
        '[tSQLt].[AssertObjectDoesNotExist] @ObjectName nvarchar(max), @Message nvarchar(max);',
        '[tSQLt].[AssertObjectExists] @ObjectName nvarchar(max), @Message nvarchar(max);',
        '[tSQLt].[AssertResultSetsHaveSameMetaData] @expectedCommand nvarchar(max), @actualCommand nvarchar(max);',
        '[tSQLt].[AssertStringIn] @Expected [tSQLt].[AssertStringTable], @Actual nvarchar(max), @Message nvarchar(max);',
        '[tSQLt].[DropClass] @ClassName nvarchar(max);',
        '[tSQLt].[ExpectException] @ExpectedMessage nvarchar(max), @ExpectedSeverity int, @ExpectedState int, @Message nvarchar(max), @ExpectedMessagePattern nvarchar(max), @ExpectedErrorNumber int;',
        '[tSQLt].[ExpectNoException] @Message nvarchar(max);',
        '[tSQLt].[Fail] @Message0 nvarchar(max), @Message1 nvarchar(max), @Message2 nvarchar(max), @Message3 nvarchar(max), @Message4 nvarchar(max), @Message5 nvarchar(max), @Message6 nvarchar(max), @Message7 nvarchar(max), @Message8 nvarchar(max), @Message9 nvarchar(max);',
        '[tSQLt].[FakeFunction] @FunctionName nvarchar(max), @FakeFunctionName nvarchar(max), @FakeDataSource nvarchar(max);',
        '[tSQLt].[FakeTable] @TableName nvarchar(max), @SchemaName nvarchar(max), @Identity bit, @ComputedColumns bit, @Defaults bit, @NotNulls bit;',
        '[tSQLt].[NewTestClass] @ClassName nvarchar(max);',
        '[tSQLt].[RemoveObject] @ObjectName nvarchar(max), @NewName nvarchar(max) OUTPUT, @IfExists int;',
        '[tSQLt].[RemoveObjectIfExists] @ObjectName nvarchar(max), @NewName nvarchar(max) OUTPUT;',
        '[tSQLt].[RenameClass] @SchemaName nvarchar(max), @NewSchemaName nvarchar(max);',
        '[tSQLt].[Run] @TestName nvarchar(max), @TestResultFormatter nvarchar(max);',
        '[tSQLt].[SpyProcedure] @ProcedureName nvarchar(max), @CommandToExecute nvarchar(max), @CallOriginal bit, @CatchExecutionTimes bit;',
        '[tSQLt].[XmlResultFormatter] ;'
    );

    EXEC tSQLt.AssertEqualsString @Expected, @Actual;
END;
GO