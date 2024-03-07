CREATE TYPE tSQLt.System_IndexColumnsType AS TABLE
(
	[object_id] [int] NOT NULL,
	[schema_name] [sysname] NOT NULL,
	[table_name] [sysname] NOT NULL,
	[index_name] [sysname] NOT NULL,
	[column_name] [sysname] NOT NULL,
	[key_ordinal] [tinyint] NOT NULL,
	[is_descending_key] [bit] NOT NULL,
	[type_desc] [nvarchar](60) NULL,
	[is_primary_key] [bit] NOT NULL,
	[is_unique] [bit] NOT NULL,
	[is_unique_constraint] [bit] NOT NULL,
	[has_filter] [bit] NOT NULL,
	[filter_definition] [nvarchar](max) NULL,
	[column_id] [int] NOT NULL,
	[is_computed] [bit] NOT NULL,
	[is_nullable] [bit] NOT NULL,
	[user_type_id] [int] NOT NULL,
	[max_length] [smallint] NOT NULL,
	[precision] [tinyint] NOT NULL,
	[scale] [tinyint] NOT NULL,
	[collation_name] [sysname] NULL
);
GO

CREATE PROCEDURE tSQLt.System_IndexColumns
	@ObjectName NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Command NVARCHAR(MAX) =
	'SELECT
		t.[object_id],
		[schema_name] = SCHEMA_NAME(t.[schema_id]),
		[table_name] = t.[name],
		[index_name] = i.[name],
		[column_name] = c.[name],
		ic.[key_ordinal],
		ic.[is_descending_key],
		i.[type_desc],
		i.[is_primary_key],
		i.[is_unique],
		i.[is_unique_constraint],
		i.[has_filter],
		i.[filter_definition],
		c.[column_id],
		c.[is_computed],
		c.[is_nullable],
		c.[user_type_id],
		c.[max_length],
		c.[precision],
		c.[scale],
		c.[collation_name]
	FROM sys.tables t
	INNER JOIN sys.indexes i ON i.[object_id] = t.[object_id]
	INNER JOIN sys.index_columns ic ON ic.[object_id] = t.[object_id] AND ic.[index_id] = i.[index_id]
	INNER JOIN sys.columns c ON c.[object_id] = t.[object_id] AND c.[column_id] = ic.[column_id]
	WHERE t.object_id = OBJECT_ID(@ObjectName)'

	EXEC tSQLt.System_ExecuteCommand @Command, @ObjectName;
END;
GO