PRINT 'Creating SqlProcedure [tSQLt].[Debug]...'
GO
CREATE PROCEDURE tSQLt.Debug
AS
BEGIN

    DECLARE @AlterFail NVARCHAR(MAX) =
'
ALTER PROCEDURE tSQLt.Fail
    @Message0 NVARCHAR(MAX) = '''',
    @Message1 NVARCHAR(MAX) = '''',
    @Message2 NVARCHAR(MAX) = '''',
    @Message3 NVARCHAR(MAX) = '''',
    @Message4 NVARCHAR(MAX) = '''',
    @Message5 NVARCHAR(MAX) = '''',
    @Message6 NVARCHAR(MAX) = '''',
    @Message7 NVARCHAR(MAX) = '''',
    @Message8 NVARCHAR(MAX) = '''',
    @Message9 NVARCHAR(MAX) = ''''
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Command NVARCHAR(MAX) = ''tSQLt.Internal_FailDebug'';
    EXEC @Command
    @Message0 = @Message0,
    @Message1 = @Message1,
    @Message2 = @Message2,
    @Message3 = @Message3,
    @Message4 = @Message4,
    @Message5 = @Message5,
    @Message6 = @Message6,
    @Message7 = @Message7,
    @Message8 = @Message8,
    @Message9 = @Message9;
END;
';
    EXEC (@AlterFail);

    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_ApplyConstraint] TO [tSQLt.TestClass];')
    EXEC ('ALTER AUTHORIZATION ON SCHEMA::[Test_AssertLike] TO [tSQLt.TestClass];')

    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_ConstraintExistsOnOtherTable]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_ConstraintNotExists]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_PrimaryKeyApplied_WithDescendingKey]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_TableNotExists]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_TableSchemaNotExists]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_TableWasNotFaked]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_ExternalCheckConstraintApplied]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_ExternalForeignKeyApplied]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_ExternalPrimaryKeyApplied]');
    EXEC ('DROP PROCEDURE [Test_ApplyConstraint].[Test_ExternalUniqueConstraintApplied]');

END;
GO

PRINT 'Running SqlProcedure [tSQLt].[Debug]...'
GO
EXEC tSQLt.Debug
GO