CREATE TYPE tSQLt.System_ParametersType AS TABLE
(
	[object_id] [int] NOT NULL,
	[name] [sysname] NULL,
	[parameter_id] [int] NOT NULL,
	[system_type_id] [tinyint] NOT NULL,
	[user_type_id] [int] NOT NULL,
	[max_length] [smallint] NOT NULL,
	[precision] [tinyint] NOT NULL,
	[scale] [tinyint] NOT NULL,
	[is_output] [bit] NOT NULL,
	[is_cursor_ref] [bit] NOT NULL,
	[has_default_value] [bit] NOT NULL,
	[is_xml_document] [bit] NOT NULL,
	[default_value] [sql_variant] NULL,
	[xml_collection_id] [int] NOT NULL,
	[is_readonly] [bit] NOT NULL,
	[is_nullable] [bit] NULL,
	[encryption_type] [int] NULL,
	[encryption_type_desc] [nvarchar](64) NULL,
	[encryption_algorithm_name] [sysname] NULL,
	[column_encryption_key_id] [int] NULL,
	[column_encryption_key_database_name] [sysname] NULL
);
GO

CREATE PROCEDURE tSQLt.System_Parameters
	@ObjectName NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SourceTable NVARCHAR(MAX) = 'sys.parameters'
	IF PARSENAME(@ObjectName, 3) IS NOT NULL
	BEGIN
		SET @SourceTable = CONCAT(QUOTENAME(PARSENAME(@ObjectName, 3)), '.', @SourceTable)
	END

	DECLARE @TableTypeColumns NVARCHAR(MAX)
	EXEC tSQLt.System_GetTableTypeColumns @TableTypeColumns OUTPUT, @TableTypeName = 'System_ParametersType'

	DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
	(
		' ',
		'DECLARE @Parameters tSQLt.System_ParametersType;',
		'INSERT INTO @Parameters SELECT', @TableTypeColumns,
		'FROM', @SourceTable,
		'WHERE object_id = OBJECT_ID(@ObjectName)',
		'SELECT * FROM @Parameters'
	);

	EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX)', @ObjectName;
END;
GO