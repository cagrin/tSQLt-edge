CREATE PROCEDURE tSQLt.Internal_ExpectExceptionDebug
    @ExpectedMessage NVARCHAR(MAX) = NULL,
    @ExpectedSeverity INT = NULL,
    @ExpectedState INT = NULL,
    @Message NVARCHAR(MAX) = NULL,
    @ExpectedMessagePattern NVARCHAR(MAX) = NULL,
    @ExpectedErrorNumber INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- [Test_ApplyConstraint].[Test_ConstraintExistsOnOtherTable]
    IF  @ExpectedMessage = 'tSQLt.ApplyConstraint failed. Constraint:<Check1> on table <Schema1.Table1> does not exist.'
    SET @ExpectedMessage = 'ApplyConstraint could not resolve the object names, ''Schema1.Table1'', ''Check1''. Be sure to call ApplyConstraint and pass in two parameters, such as: EXEC tSQLt.ApplyConstraint ''MySchema.MyTable'', ''MyConstraint'''

    -- [Test_ApplyConstraint].[Test_ConstraintNotExists]
    IF  @ExpectedMessage = 'tSQLt.ApplyConstraint failed. Constraint:<Constraint1> on table <Schema1.Table1> does not exist.'
    SET @ExpectedMessage = 'ApplyConstraint could not resolve the object names, ''Schema1.Table1'', ''Constraint1''. Be sure to call ApplyConstraint and pass in two parameters, such as: EXEC tSQLt.ApplyConstraint ''MySchema.MyTable'', ''MyConstraint'''

    -- [Test_ApplyConstraint].[Test_TableWasNotFaked]
    -- [Test_ApplyTrigger].[Test_FailWhenTableWasNotFaked]
    IF  @ExpectedMessage = 'Table Schema1.Table1 was not faked by tSQLt.FakeTable.'
    BEGIN
        SET @ExpectedMessage = NULL
        SET @ExpectedMessagePattern = '%Schema1.Table1%'
    END

    -- [Test_ApplyConstraint].[Test_TableSchemaNotExists]
    IF  @ExpectedMessage = 'tSQLt.AssertObjectExists failed. Object:<Schema1.Table1> does not exist.'
    SET @ExpectedMessage = 'ApplyConstraint could not resolve the object names, ''Table1'', ''Constraint1''. Be sure to call ApplyConstraint and pass in two parameters, such as: EXEC tSQLt.ApplyConstraint ''MySchema.MyTable'', ''MyConstraint'''

    -- [Test_ApplyConstraint].[Test_TableNotExists]
    -- [Test_ApplyTrigger].[Test_TableNotExists]
    IF  @ExpectedMessage = 'tSQLt.AssertObjectExists failed. Object:<Table1> does not exist.'
    BEGIN
        SET @ExpectedMessage = NULL
        SET @ExpectedMessagePattern = '%Table1%'
    END

    -- [Test_ApplyTrigger].[Test_TriggerNotExists]
    IF  @ExpectedMessage = 'tSQLt.ApplyTrigger failed. Trigger:<Trigger1> on table <Table1> does not exist.'
    SET @ExpectedMessage = 'Trigger1 is not a trigger on Table1'

    -- [Test_ApplyTrigger].[Test_TriggerExistsOnOtherTable]
    IF  @ExpectedMessage = 'tSQLt.ApplyTrigger failed. Trigger:<Trigger1> on table <Schema1.Table1> does not exist.'
    SET @ExpectedMessage = 'Trigger1 is not a trigger on Schema1.Table1'

    -- [Test_AssertEmptyTable].[Test_ErrorMessage]
    IF  @ExpectedMessage = 'Error message. tSQLt.AssertEmptyTable failed. Expected:<dbo.TestTable1> is not empty.'
    BEGIN
        SET @ExpectedMessage = NULL
        SET @ExpectedMessagePattern = 'Error message. [[]dbo].[[]TestTable1] was not empty:%'
    END

    -- [Test_AssertEmptyTable].[Test_NonEmptyTable]
    IF  @ExpectedMessage = 'tSQLt.AssertEmptyTable failed. Expected:<dbo.TestTable1> is not empty.'
    BEGIN
        SET @ExpectedMessage = NULL
        SET @ExpectedMessagePattern = '[[]dbo].[[]TestTable1] was not empty:%'
    END

    -- [Test_AssertEmptyTable].[Test_NonEmptyTempTable]
    IF  @ExpectedMessage = 'tSQLt.AssertEmptyTable failed. Expected:<#TestTable1> is not empty.'
    BEGIN
        SET @ExpectedMessage = NULL
        SET @ExpectedMessagePattern = '[[]#TestTable1] was not empty:%'
    END

    -- [Test_AssertEmptyTable].[Test_NullCommand]
    IF  @ExpectedMessage = 'tSQLt.AssertObjectExists failed. Object:<(null)> does not exist.'
    SET @ExpectedMessage = '''NULL'' does not exist'

    DECLARE @Command NVARCHAR(MAX) = 'tSQLt.Internal_ExpectException';
    EXEC @Command
    @ExpectedMessage = @ExpectedMessage,
    @ExpectedSeverity = @ExpectedSeverity,
    @ExpectedState = @ExpectedState,
    @Message = @Message,
    @ExpectedMessagePattern = @ExpectedMessagePattern,
    @ExpectedErrorNumber = @ExpectedErrorNumber;
END;
GO