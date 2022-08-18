CREATE TYPE tSQLt.System_ObjectsType AS TABLE
(
	[name] [sysname] NOT NULL,
	[object_id] [int] NOT NULL,
	[principal_id] [int] NULL,
	[schema_id] [int] NOT NULL,
	[parent_object_id] [int] NOT NULL,
	[type] [char](2) NULL,
	[type_desc] [nvarchar](60) NULL,
	[create_date] [datetime] NOT NULL,
	[modify_date] [datetime] NOT NULL,
	[is_ms_shipped] [bit] NOT NULL,
	[is_published] [bit] NOT NULL,
	[is_schema_published] [bit] NOT NULL
);
GO

CREATE PROCEDURE tSQLt.System_Objects
	@ObjectName NVARCHAR(MAX),
	@ParentObjectFilter BIT = 0
AS
BEGIN
	DECLARE @TableTypeName NVARCHAR(MAX) = 'System_ObjectsType'

	DECLARE @SourceTable NVARCHAR(MAX) = 'sys.objects'
	IF PARSENAME(@ObjectName, 3) IS NOT NULL
	BEGIN
		SET @SourceTable = CONCAT(QUOTENAME(PARSENAME(@ObjectName, 3)), '.', @SourceTable)
	END

	DECLARE @ObjectFilter NVARCHAR(MAX) = 'object_id'
	IF @ParentObjectFilter = 1
	BEGIN
		SET @ObjectFilter = 'parent_object_id'
	END

	DECLARE @TableTypeColumns NVARCHAR(MAX)
	EXEC tSQLt.System_GetTableTypeColumns @TableTypeColumns OUTPUT, @TableTypeName

	DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
	(
		' ',
		'DECLARE @Objects tSQLt.', @TableTypeName,
		'INSERT INTO @Objects SELECT', @TableTypeColumns,
		'FROM', @SourceTable,
		CASE WHEN @ObjectName IS NOT NULL THEN CONCAT('WHERE ', @ObjectFilter, ' = OBJECT_ID(@ObjectName)') ELSE '' END,
		'SELECT * FROM @Objects'
	);

	EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX)', @ObjectName;
END;
GO