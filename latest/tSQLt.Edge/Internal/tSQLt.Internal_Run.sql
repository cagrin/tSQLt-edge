CREATE PROCEDURE tSQLt.Internal_Run
    @TestName NVARCHAR(MAX) = NULL,
    @TestResultFormatter NVARCHAR(MAX) = NULL
AS
BEGIN
    IF @TestResultFormatter IS NOT NULL
    BEGIN
        EXEC tSQLt.Fail 'tSQLt.Run with @TestResultFormatter is not supported.';
    END

    DELETE FROM tSQLt.TestResult;

    DECLARE @TestNames tSQLt.Private_TestNamesType;
    INSERT INTO @TestNames EXEC tSQLt.Private_TestNames @TestName;
    DECLARE @TestNamesOrdered TABLE (Id INT IDENTITY(1,1), TestName NVARCHAR(MAX) NOT NULL);
    INSERT INTO @TestNamesOrdered (TestName) SELECT TestName FROM @TestNames ORDER BY TestName;
    DECLARE @TestCase NVARCHAR(MAX), @TestTime DATETIME2, @ErrorMessage NVARCHAR(MAX), @Idx int = 1, @Max int = (SELECT COUNT(1) FROM @TestNames);
    DECLARE @TranName CHAR(32); EXEC tSQLt.Private_GetNewTranName @TranName OUTPUT;

    WHILE @Idx <= @Max
    BEGIN
        SET @TestCase = (SELECT TestName FROM @TestNamesOrdered WHERE Id = @Idx)

        SET @TestTime = SYSDATETIME()
        INSERT INTO tSQLt.TestResult (Class, TestCase, TranName, TestStartTime)
        SELECT
            Class = OBJECT_SCHEMA_NAME(OBJECT_ID(@TestCase)),
            TestCase = OBJECT_NAME(OBJECT_ID(@TestCase)),
            TranName = @TranName,
            TestStartTime = @TestTime;
        DECLARE @Id INT = SCOPE_IDENTITY();

        EXEC tSQLt.Private_Run @TestCase, @TranName, @ErrorMessage OUTPUT;

        SET @TestTime = SYSDATETIME()
        UPDATE tSQLt.TestResult SET
            Result = CASE WHEN @ErrorMessage IS NOT NULL THEN 'Failure' ELSE 'Success' END,
            Msg = @ErrorMessage,
            TestEndTime = @TestTime
        WHERE Id = @Id;

        SET @Idx = @Idx + 1;
    END

    IF @@TRANCOUNT = 0
    BEGIN
        EXEC tSQLt.Private_ResultLog;
    END
END;
GO