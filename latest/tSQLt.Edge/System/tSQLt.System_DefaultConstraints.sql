CREATE TYPE tSQLt.System_DefaultConstraintsType AS TABLE
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
	[is_schema_published] [bit] NOT NULL,
	[parent_column_id] [int] NOT NULL,
	[definition] [nvarchar](max) NULL,
	[is_system_named] [bit] NOT NULL
);
GO

CREATE PROCEDURE tSQLt.System_DefaultConstraints
	@ObjectName NVARCHAR(MAX),
	@ColumnId INT
AS
BEGIN
	DECLARE @TableTypeName NVARCHAR(MAX) = 'System_DefaultConstraintsType'
	DECLARE @SourceTable NVARCHAR(MAX) = 'sys.default_constraints'
	IF OBJECT_ID(CONCAT('tempdb..', @ObjectName)) IS NOT NULL
	BEGIN
		SET @SourceTable = CONCAT('tempdb.', @SourceTable)
		SET @ObjectName = CONCAT('tempdb..', @ObjectName)
	END
	ELSE IF PARSENAME(@ObjectName, 3) IS NOT NULL
	BEGIN
		SET @SourceTable = CONCAT(QUOTENAME(PARSENAME(@ObjectName, 3)), '.', @SourceTable)
	END

	DECLARE @TableTypeColumns NVARCHAR(MAX)
	EXEC tSQLt.System_GetTableTypeColumns @TableTypeColumns OUTPUT, @TableTypeName

	DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
	(
		' ',
		'SELECT', @TableTypeColumns,
		'FROM', @SourceTable,
		'WHERE parent_object_id = OBJECT_ID(@ObjectName) AND parent_column_id = @ColumnId'
	);

	EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX), @ColumnId INT', @ObjectName, @ColumnId;
END;
GO