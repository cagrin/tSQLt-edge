CREATE PROCEDURE tSQLt.Internal_Run
    @TestName NVARCHAR(MAX) = NULL
AS
BEGIN
    DELETE FROM tSQLt.TestResult;

    DECLARE @TestNames TABLE (Id INT IDENTITY(1,1), TestName NVARCHAR(MAX) NOT NULL);
    INSERT INTO @TestNames (TestName) SELECT TestName FROM tSQLt.Private_FindTestNames(@TestName) ORDER BY TestName;
    DECLARE @TestCase NVARCHAR(MAX), @ErrorMessage NVARCHAR(MAX), @Idx int = 1, @Max int = (SELECT COUNT(1) FROM @TestNames);
    DECLARE @TranName CHAR(32); EXEC tSQLt.Private_GetNewTranName @TranName OUTPUT;

    WHILE @Idx <= @Max
    BEGIN
        SET @TestCase = (SELECT TestName FROM @TestNames WHERE Id = @Idx)

        INSERT INTO tSQLt.TestResult (Class, TestCase, TranName)
        SELECT
            Class = OBJECT_SCHEMA_NAME(OBJECT_ID(@TestCase)),
            TestCase = OBJECT_NAME(OBJECT_ID(@TestCase)),
            TranName = @TranName;
        DECLARE @Id INT = SCOPE_IDENTITY();

        EXEC tSQLt.Private_Run @TestCase, @TranName, @ErrorMessage OUTPUT;

        UPDATE tSQLt.TestResult SET
            Result = CASE WHEN @ErrorMessage IS NOT NULL THEN 'Failure' ELSE 'Success' END,
            Msg = @ErrorMessage,
            TestEndTime = SYSDATETIME()
        WHERE Id = @Id;

        SET @Idx = @Idx + 1;
    END

    IF @@TRANCOUNT = 0
    BEGIN
        EXEC tSQLt.Private_ResultLog;
    END
END;
GO