CREATE SCHEMA Test_RunAll;
GO

CREATE PROCEDURE Test_RunAll.Test_Interfaces
AS
BEGIN
    DECLARE @Actual NVARCHAR(MAX);

    SELECT @Actual = STRING_AGG(CONVERT(NVARCHAR(MAX), command),NCHAR(10))
    FROM
    (
        SELECT
            command = FORMATMESSAGE
            (
                'EXEC %s%s;',
                spname,
                STRING_AGG(pvalue, ',') WITHIN GROUP (ORDER BY parameter_id)
            )
        FROM
        (
            SELECT TOP (100) PERCENT
                spname = FORMATMESSAGE('%s.%s', QUOTENAME(SCHEMA_NAME(r.schema_id)), QUOTENAME(r.name)),
                pvalue = CASE WHEN p.name IS NOT NULL THEN FORMATMESSAGE(' %s', p.name) ELSE '' END,
                p.parameter_id
            FROM sys.procedures r
            LEFT JOIN sys.parameters p
            ON p.object_id = r.object_id
            WHERE SCHEMA_NAME(r.schema_id) = 'tSQLt'
            AND r.name NOT LIKE 'Internal[_]%'
            AND r.name NOT LIKE 'Private[_]%'
            AND r.name <> 'RunAll'
            ORDER BY r.name, p.parameter_id
        ) A
        GROUP BY spname
    ) B

    DECLARE @Expected NVARCHAR(MAX) =
'EXEC [tSQLt].[ApplyConstraint] @TableName, @ConstraintName, @SchemaName, @NoCascade;
EXEC [tSQLt].[ApplyTrigger] @TableName, @TriggerName;
EXEC [tSQLt].[AssertEmptyTable] @TableName, @Message;
EXEC [tSQLt].[AssertEquals] @Expected, @Actual, @Message;
EXEC [tSQLt].[AssertEqualsString] @Expected, @Actual, @Message;
EXEC [tSQLt].[AssertEqualsTable] @Expected, @Actual, @Message, @FailMsg;
EXEC [tSQLt].[AssertEqualsTableSchema] @Expected, @Actual, @Message;
EXEC [tSQLt].[AssertLike] @ExpectedPattern, @Actual, @Message;
EXEC [tSQLt].[AssertNotEquals] @Expected, @Actual, @Message;
EXEC [tSQLt].[AssertObjectDoesNotExist] @ObjectName, @Message;
EXEC [tSQLt].[AssertObjectExists] @ObjectName, @Message;
EXEC [tSQLt].[AssertResultSetsHaveSameMetaData] @expectedCommand, @actualCommand;
EXEC [tSQLt].[DropClass] @ClassName;
EXEC [tSQLt].[ExpectException] @ExpectedMessage, @ExpectedSeverity, @ExpectedState, @Message, @ExpectedMessagePattern, @ExpectedErrorNumber;
EXEC [tSQLt].[ExpectNoException] @Message;
EXEC [tSQLt].[Fail] @Message0, @Message1, @Message2, @Message3, @Message4, @Message5, @Message6, @Message7, @Message8, @Message9;
EXEC [tSQLt].[FakeFunction] @FunctionName, @FakeFunctionName, @FakeDataSource;
EXEC [tSQLt].[FakeTable] @TableName, @SchemaName, @Identity, @ComputedColumns, @Defaults;
EXEC [tSQLt].[NewTestClass] @ClassName;
EXEC [tSQLt].[RemoveObject] @ObjectName, @NewName, @IfExists;
EXEC [tSQLt].[RemoveObjectIfExists] @ObjectName, @NewName;
EXEC [tSQLt].[RenameClass] @SchemaName, @NewSchemaName;
EXEC [tSQLt].[Run] @TestName;
EXEC [tSQLt].[SpyProcedure] @ProcedureName, @CommandToExecute;';

    EXEC tSQLt.AssertEqualsString @Expected, @Actual;
END;
GO