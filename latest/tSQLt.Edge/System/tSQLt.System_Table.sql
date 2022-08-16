CREATE PROCEDURE tSQLt.System_Table
	@SysTableType NVARCHAR(MAX) = 'System_ObjectsType',
	@SysTableName NVARCHAR(MAX) = 'sys.objects',
	@ObjectName NVARCHAR(MAX) = NULL
AS
BEGIN
	DECLARE @DatabaseName NVARCHAR(MAX)
	IF PARSENAME(@ObjectName, 3) IS NOT NULL
	BEGIN
		SET @DatabaseName = CONCAT(QUOTENAME(PARSENAME(@ObjectName, 3)), '.')
	END

	DECLARE @TableTypeColumns NVARCHAR(MAX)
	EXEC tSQLt.System_GetTableTypeColumns @TableTypeColumns OUTPUT, @SysTableType

	DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
	(
		' ',
		'DECLARE @Objects tSQLt.', @SysTableType,
		'INSERT INTO @Objects SELECT', @TableTypeColumns,
		'FROM', @DatabaseName, @SysTableName,
		'SELECT * FROM @Objects'
	);

	EXEC (@Command);
END;
GO