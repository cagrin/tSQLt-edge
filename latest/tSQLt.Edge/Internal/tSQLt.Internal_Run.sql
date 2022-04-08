CREATE PROCEDURE tSQLt.Internal_Run
    @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
    DELETE FROM tSQLt.TestResult;

    DECLARE @TestNames TABLE (Id INT IDENTITY(1,1), TestName NVARCHAR(MAX) NOT NULL);
    INSERT INTO @TestNames (TestName) SELECT TestName FROM tSQLt.Private_FindTestNames(@TestName) ORDER BY TestName;
    DECLARE @TestCase NVARCHAR(MAX), @ErrorMessage NVARCHAR(MAX), @Idx int = 1, @Max int = (SELECT COUNT(1) FROM @TestNames);

    WHILE @Idx <= @Max
    BEGIN
        SET @TestCase = (SELECT TestName FROM @TestNames WHERE Id = @Idx)
        EXEC tSQLt.Private_Run @TestCase, @ErrorMessage OUTPUT;

        INSERT INTO tSQLt.TestResult (Class, TestCase, Result, Msg)
        VALUES
        (
            OBJECT_SCHEMA_NAME(OBJECT_ID(@TestCase)),
            OBJECT_NAME(OBJECT_ID(@TestCase)),
            CASE WHEN @ErrorMessage IS NOT NULL THEN 'Failure' ELSE 'Success' END,
            @ErrorMessage
        );

        SET @Idx = @Idx + 1;
    END

    SET @ErrorMessage = (SELECT TOP 1 Msg FROM tSQLt.TestResult WHERE Result <> 'Success' ORDER BY [Name])
    IF @ErrorMessage IS NOT NULL
        RAISERROR(N'%s', 16, 10, @ErrorMessage);

    IF @@TRANCOUNT = 0
        SELECT
            Passed = (SELECT COUNT(1) FROM tSQLt.TestResult WHERE Result = 'Success'),
            Failed = (SELECT COUNT(1) FROM tSQLt.TestResult WHERE Result = 'Failure');
END;
GO