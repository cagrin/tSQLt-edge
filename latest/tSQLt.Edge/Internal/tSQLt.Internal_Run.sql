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

        INSERT INTO tSQLt.TestResult (Class, TestCase)
        SELECT
            Class = OBJECT_SCHEMA_NAME(OBJECT_ID(@TestCase)),
            TestCase = OBJECT_NAME(OBJECT_ID(@TestCase));
        DECLARE @Id INT = SCOPE_IDENTITY();

        EXEC tSQLt.Private_Run @TestCase, @ErrorMessage OUTPUT;

        UPDATE tSQLt.TestResult SET
            Result = CASE WHEN @ErrorMessage IS NOT NULL THEN 'Failure' ELSE 'Success' END,
            Msg = @ErrorMessage,
            TestEndTime = SYSDATETIME()
        WHERE Id = @Id;

        SET @Idx = @Idx + 1;
    END

    IF @@TRANCOUNT = 0
    BEGIN
        DECLARE @Failed INT = (SELECT ISNULL(COUNT(1), 0) FROM tSQLt.TestResult WHERE Result = 'Failure');
        DECLARE @Passed INT = (SELECT ISNULL(COUNT(1), 0) FROM tSQLt.TestResult WHERE Result = 'Success');

        SELECT Failed = @Failed, Passed = @Passed

        IF @Failed > 0
            SELECT Name, Msg FROM tSQLt.TestResult WHERE Result = 'Failure'
    END
END;
GO