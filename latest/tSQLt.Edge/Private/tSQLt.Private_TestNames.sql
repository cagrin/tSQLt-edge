CREATE TYPE tSQLt.Private_TestNamesType AS TABLE
(
	TestName NVARCHAR(MAX) NOT NULL
);
GO

CREATE PROCEDURE tSQLt.Private_TestNames
	@TestName NVARCHAR(MAX)
AS
BEGIN
	DECLARE @TestNames tSQLt.Private_TestNamesType

	INSERT INTO @TestNames
	SELECT CONCAT
	(
		QUOTENAME(SCHEMA_NAME(schema_id)),
		'.',
		QUOTENAME(name)
	)
	FROM tSQLt.System_Tests(@TestName)

    SELECT TestName FROM @TestNames
END;
GO