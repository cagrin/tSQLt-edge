CREATE TYPE tSQLt.System_IndexColumnsType AS TABLE
(
	[object_id] [int] NOT NULL,
	[schema_id] [int] NOT NULL,
	[table_name] [sysname] NOT NULL,
	[index_name] [sysname] NULL,
	[column_name] [sysname] NULL,
	[key_ordinal] [tinyint] NOT NULL,
	[is_descending_key] [bit] NULL,
	[type_desc] [nvarchar](60) NULL,
	[is_primary_key] [bit] NULL,
	[is_unique] [bit] NULL,
	[is_unique_constraint] [bit] NULL,
	[has_filter] [bit] NULL,
	[filter_definition] [nvarchar](max) NULL,
	[column_id] [int] NOT NULL,
	[is_computed] [bit] NOT NULL,
	[is_nullable] [bit] NULL,
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
	DECLARE @DatabaseName NVARCHAR(MAX)
	IF PARSENAME(@ObjectName, 3) IS NOT NULL
	BEGIN
		SET @DatabaseName = CONCAT(QUOTENAME(PARSENAME(@ObjectName, 3)), '.')
	END

	DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
	(
		' ',
		'SELECT
			t.[object_id],
			t.[schema_id],
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
		FROM', @DatabaseName, 'sys.tables t',
		'INNER JOIN ', @DatabaseName, 'sys.indexes i ON i.[object_id] = t.[object_id]',
		'INNER JOIN ', @DatabaseName, 'sys.index_columns ic ON ic.[object_id] = t.[object_id] AND ic.[index_id] = i.[index_id]',
		'INNER JOIN ', @DatabaseName, 'sys.columns c ON c.[object_id] = t.[object_id] AND c.[column_id] = ic.[column_id]',
		'WHERE t.object_id = OBJECT_ID(@ObjectName)'
	);

	EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX)', @ObjectName;
END;
GO