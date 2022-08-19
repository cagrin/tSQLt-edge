CREATE TYPE tSQLt.System_IdentityColumnsType AS TABLE
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
	[is_filestream] [bit] NOT NULL,
	[is_replicated] [bit] NULL,
	[is_non_sql_subscribed] [bit] NULL,
	[is_merge_published] [bit] NULL,
	[is_dts_replicated] [bit] NULL,
	[is_xml_document] [bit] NOT NULL,
	[xml_collection_id] [int] NOT NULL,
	[default_object_id] [int] NOT NULL,
	[rule_object_id] [int] NOT NULL,
	[seed_value] [sql_variant] NULL,
	[increment_value] [sql_variant] NULL,
	[last_value] [sql_variant] NULL,
	[is_not_for_replication] [bit] NULL,
	[is_computed] [bit] NOT NULL,
	[is_sparse] [bit] NOT NULL,
	[is_column_set] [bit] NOT NULL,
	[generated_always_type] [tinyint] NULL,
	[generated_always_type_desc] [nvarchar](60) NULL,
	[encryption_type] [int] NULL,
	[encryption_type_desc] [nvarchar](64) NULL,
	[encryption_algorithm_name] [nvarchar](128) NULL,
	[column_encryption_key_id] [int] NULL,
	[column_encryption_key_database_name] [sysname] NULL,
	[is_hidden] [bit] NOT NULL,
	[is_masked] [bit] NOT NULL,
	[graph_type] [int] NULL,
	[graph_type_desc] [nvarchar](60) NULL
);
GO

CREATE PROCEDURE tSQLt.System_IdentityColumns
	@ObjectName NVARCHAR(MAX),
	@ColumnId INT
AS
BEGIN
	DECLARE @TableTypeName NVARCHAR(MAX) = 'System_IdentityColumnsType'
	DECLARE @SourceTable NVARCHAR(MAX) = 'sys.identity_columns'
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
		'WHERE object_id = OBJECT_ID(@ObjectName) AND column_id = @ColumnId'
	);

	EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX), @ColumnId INT', @ObjectName, @ColumnId;
END;
GO