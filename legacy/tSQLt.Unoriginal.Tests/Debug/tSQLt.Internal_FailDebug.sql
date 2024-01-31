CREATE PROCEDURE tSQLt.Internal_FailDebug
    @Message0 NVARCHAR(MAX) = '',
    @Message1 NVARCHAR(MAX) = '',
    @Message2 NVARCHAR(MAX) = '',
    @Message3 NVARCHAR(MAX) = '',
    @Message4 NVARCHAR(MAX) = '',
    @Message5 NVARCHAR(MAX) = '',
    @Message6 NVARCHAR(MAX) = '',
    @Message7 NVARCHAR(MAX) = '',
    @Message8 NVARCHAR(MAX) = '',
    @Message9 NVARCHAR(MAX) = ''
AS
BEGIN
    DECLARE @ErrorMessage NVARCHAR(MAX) = CONCAT_WS
    (
        ' ',
        NULLIF(@Message0, ''),
        NULLIF(@Message1, ''),
        NULLIF(@Message2, ''),
        NULLIF(@Message3, ''),
        NULLIF(@Message4, ''),
        NULLIF(@Message5, ''),
        NULLIF(@Message6, ''),
        NULLIF(@Message7, ''),
        NULLIF(@Message8, ''),
        NULLIF(@Message9, '')
    );

    DECLARE @NL NVARCHAR(MAX) = CHAR(13) + CHAR(10);

    -- [Test_AssertLike].[Test_NullH_llo]
    IF  @ErrorMessage LIKE '__Expected: <H[_]llo>__ but was: <NULL>'
    SET @ErrorMessage = 'tSQLt.AssertLike failed. ExpectedPattern:<H_llo> but Actual:<(null)>.';

    -- [Test_AssertLike].[Test_NullH_o]
    IF  @ErrorMessage LIKE '__Expected: <H[%]o>__ but was: <NULL>'
    SET @ErrorMessage = 'tSQLt.AssertLike failed. ExpectedPattern:<H%o> but Actual:<(null)>.';

    -- [Test_AssertLike].[Test_NullPattern]
    IF  @ErrorMessage LIKE '__Expected: <NULL>__ but was: <Hello>'
    SET @ErrorMessage = 'tSQLt.AssertLike failed. ExpectedPattern:<(null)> but Actual:<Hello>.';

    -- [Test_AssertLike].[Test_ErrorMessage]
    IF  @ErrorMessage LIKE 'Error message. __Expected: <NULL>__ but was: <Hello>'
    SET @ErrorMessage = 'Error message. tSQLt.AssertLike failed. ExpectedPattern:<(null)> but Actual:<Hello>.';

    RAISERROR(N'%s', 16, 10, @ErrorMessage);
END;
GO