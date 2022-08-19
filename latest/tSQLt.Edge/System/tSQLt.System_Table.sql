CREATE PROCEDURE tSQLt.System_Table
	@SysTableType NVARCHAR(MAX) = 'System_ObjectsType',
	@SysTableName NVARCHAR(MAX) = 'sys.objects',
	@ObjectName NVARCHAR(MAX)
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
		'SELECT', @TableTypeColumns,
		'FROM', @DatabaseName, @SysTableName,
		CASE WHEN @ObjectName IS NOT NULL THEN 'WHERE object_id = OBJECT_ID(@ObjectName)' ELSE '' END
	);

	EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX)', @ObjectName;
END;
GO