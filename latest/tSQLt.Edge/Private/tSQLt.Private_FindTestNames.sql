CREATE FUNCTION tSQLt.Private_FindTestNames (@TestName NVARCHAR(MAX))
RETURNS @Tests TABLE
(
	TestName NVARCHAR(MAX) NOT NULL
) AS
BEGIN
	INSERT INTO @Tests
	SELECT CONCAT
	(
		QUOTENAME(SCHEMA_NAME(schema_id)),
		'.',
		QUOTENAME(name)
	)
	FROM tSQLt.System_Tests(@TestName)

    RETURN;
END;
GO