CREATE TYPE tSQLt.System_ComputedColumnsType AS TABLE
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
	[definition] [nvarchar](max) NULL,
	[uses_database_collation] [bit] NOT NULL,
	[is_persisted] [bit] NOT NULL,
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

CREATE PROCEDURE tSQLt.System_ComputedColumns
	@ObjectName NVARCHAR(MAX),
	@ColumnId INT
AS
BEGIN
	DECLARE @Command NVARCHAR(MAX) =
	'SELECT
		[object_id],
		[name],
		[column_id],
		[system_type_id],
		[user_type_id],
		[max_length],
		[precision],
		[scale],
		[collation_name],
		[is_nullable],
		[is_ansi_padded],
		[is_rowguidcol],
		[is_identity],
		[is_filestream],
		[is_replicated],
		[is_non_sql_subscribed],
		[is_merge_published],
		[is_dts_replicated],
		[is_xml_document],
		[xml_collection_id],
		[default_object_id],
		[rule_object_id],
		[definition],
		[uses_database_collation],
		[is_persisted],
		[is_computed],
		[is_sparse],
		[is_column_set],
		[generated_always_type],
		[generated_always_type_desc],
		[encryption_type],
		[encryption_type_desc],
		[encryption_algorithm_name],
		[column_encryption_key_id],
		[column_encryption_key_database_name],
		[is_hidden],
		[is_masked],
		[graph_type],
		[graph_type_desc]
	FROM sys.computed_columns
	WHERE object_id = OBJECT_ID(@ObjectName) AND column_id = @ColumnId'

	IF OBJECT_ID(CONCAT('tempdb..', @ObjectName)) IS NOT NULL
	BEGIN
		SET @Command = REPLACE(@Command, 'FROM sys.', 'FROM tempdb.sys.')
		SET @Command = REPLACE(@Command, '@ObjectName', 'CONCAT(''tempdb..'', @ObjectName)')
	END

	EXEC tSQLt.System_ExecuteCommand_ColumnId @Command, @ObjectName, @ColumnId;
END;
GO