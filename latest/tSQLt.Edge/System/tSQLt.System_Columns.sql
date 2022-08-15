CREATE TYPE tSQLt.System_ColumnsType AS TABLE
(
	[object_id] [int] NOT NULL,
	[name] [sysname] NULL,
	[column_id] [int] NOT NULL,
	[system_type_id] [tinyint] NOT NULL,
	[user_type_id] [int] NOT NULL,
	[max_length] [smallint] NOT NULL,
	[precision] [tinyint] NOT NULL,
	[scale] [tinyint] NOT NULL,
	[collation_name] [sysname] NULL,
	[is_nullable] [bit] NULL,
	[is_ansi_padded] [bit] NOT NULL,
	[is_rowguidcol] [bit] NOT NULL,
	[is_identity] [bit] NOT NULL,
	[is_computed] [bit] NOT NULL,
	[is_filestream] [bit] NOT NULL,
	[is_replicated] [bit] NULL,
	[is_non_sql_subscribed] [bit] NULL,
	[is_merge_published] [bit] NULL,
	[is_dts_replicated] [bit] NULL,
	[is_xml_document] [bit] NOT NULL,
	[xml_collection_id] [int] NOT NULL,
	[default_object_id] [int] NOT NULL,
	[rule_object_id] [int] NOT NULL,
	[is_sparse] [bit] NULL,
	[is_column_set] [bit] NULL,
	[generated_always_type] [tinyint] NULL,
	[generated_always_type_desc] [nvarchar](60) NULL,
	[encryption_type] [int] NULL,
	[encryption_type_desc] [nvarchar](64) NULL,
	[encryption_algorithm_name] [sysname] NULL,
	[column_encryption_key_id] [int] NULL,
	[column_encryption_key_database_name] [sysname] NULL,
	[is_hidden] [bit] NULL,
	[is_masked] [bit] NOT NULL,
	[graph_type] [int] NULL,
	[graph_type_desc] [nvarchar](60) NULL
);
GO

CREATE PROCEDURE tSQLt.System_Columns
	@ObjectName NVARCHAR(MAX)
AS
BEGIN
	DECLARE
		@SourceTable NVARCHAR(MAX) = 'sys.columns',
		@SourceObject NVARCHAR(MAX) = CONCAT('OBJECT_ID(''', REPLACE(@ObjectName, '''', ''''''), ''')')

	IF OBJECT_ID(CONCAT('tempdb..', @ObjectName)) IS NOT NULL
	BEGIN
		SET @SourceTable = 'tempdb.sys.columns'
		SET @SourceObject = CONCAT('OBJECT_ID(CONCAT(''tempdb..'',''', REPLACE(@ObjectName, '''', ''''''), '''))')
	END
	ELSE IF PARSENAME(@ObjectName, 3) IS NOT NULL
	BEGIN
		SET @SourceTable = CONCAT(QUOTENAME(PARSENAME(@ObjectName, 3)), '.', @SourceTable)
	END

	DECLARE @TableTypeColumns NVARCHAR(MAX)
	EXEC tSQLt.System_GetTableTypeColumns @TableTypeColumns OUTPUT, @TableTypeName = 'System_ColumnsType'

	DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
	(
		' ',
		'DECLARE @Columns tSQLt.System_ColumnsType;',
		'INSERT INTO @Columns SELECT', @TableTypeColumns,
		'FROM', @SourceTable,
		'WHERE object_id =', @SourceObject,
		'SELECT * FROM @Columns'
	);

	EXEC (@Command);
END;
GO