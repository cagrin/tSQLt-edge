CREATE PROCEDURE tSQLt.Private_RunTestSetUp
    @TestName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @TestSetUp NVARCHAR(MAX) = CONCAT
    (
        QUOTENAME(OBJECT_SCHEMA_NAME(OBJECT_ID(@TestName))),
        '.[SetUp]'
    );

    IF OBJECT_ID(@TestSetUp) IS NOT NULL
    BEGIN
        EXEC @TestSetUp;
    END
END;
GO