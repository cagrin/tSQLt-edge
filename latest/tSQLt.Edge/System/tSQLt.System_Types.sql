CREATE TYPE tSQLt.System_TypesType AS TABLE
(
	[name] [sysname] NOT NULL,
	[system_type_id] [tinyint] NOT NULL,
	[user_type_id] [int] NOT NULL,
	[schema_id] [int] NOT NULL,
	[principal_id] [int] NULL,
	[max_length] [smallint] NOT NULL,
	[precision] [tinyint] NOT NULL,
	[scale] [tinyint] NOT NULL,
	[collation_name] [sysname] NULL,
	[is_nullable] [bit] NULL,
	[is_user_defined] [bit] NOT NULL,
	[is_assembly_type] [bit] NOT NULL,
	[default_object_id] [int] NOT NULL,
	[rule_object_id] [int] NOT NULL,
	[is_table_type] [bit] NOT NULL
);
GO

CREATE PROCEDURE tSQLt.System_Types
	@TypeId INT,
	@ObjectName NVARCHAR(MAX) = NULL
AS
BEGIN
	DECLARE @SourceTable NVARCHAR(MAX) = 'sys.types'
	IF PARSENAME(@ObjectName, 3) IS NOT NULL
	BEGIN
		SET @SourceTable = CONCAT(QUOTENAME(PARSENAME(@ObjectName, 3)), '.', @SourceTable)
	END

	DECLARE @TableTypeColumns NVARCHAR(MAX)
	EXEC tSQLt.System_GetTableTypeColumns @TableTypeColumns OUTPUT, @TableTypeName = 'System_TypesType'

	DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
	(
		' ',
		'DECLARE @Types tSQLt.System_TypesType',
		'INSERT INTO @Types SELECT', @TableTypeColumns,
		'FROM', @SourceTable,
		'WHERE user_type_id = @TypeId',
		'SELECT * FROM @Types'
	);

	EXEC sys.sp_executesql @Command, N'@TypeId INT', @TypeId;
END;
GO