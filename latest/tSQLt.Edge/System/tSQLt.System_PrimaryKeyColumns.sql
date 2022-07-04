CREATE FUNCTION tSQLt.System_PrimaryKeyColumns ()
RETURNS @PrimaryKeyColumns TABLE
(
	[object_id] [int] NOT NULL,
	[schema_id] [int] NOT NULL,
	[table_name] [sysname] NOT NULL,
	[index_name] [sysname] NULL,
	[column_name] [sysname] NULL,
	[key_ordinal] [tinyint] NOT NULL,
	[is_descending_key] [bit] NULL,
	[type_desc] [nvarchar](60) NULL,
	[column_id] [int] NOT NULL,
	[is_computed] [bit] NOT NULL,
	[is_nullable] [bit] NULL,
	[user_type_id] [int] NOT NULL,
	[max_length] [smallint] NOT NULL,
	[precision] [tinyint] NOT NULL,
	[scale] [tinyint] NOT NULL,
	[collation_name] [sysname] NULL
) AS
BEGIN
    INSERT INTO @PrimaryKeyColumns
	SELECT
		t.[object_id],
		t.[schema_id],
		[table_name] = t.[name],
		[index_name] = i.[name],
		[column_name] = c.[name],
		ic.[key_ordinal],
		ic.[is_descending_key],
		i.[type_desc],
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
	WHERE i.[is_primary_key] = 1

    RETURN;
END;
GO