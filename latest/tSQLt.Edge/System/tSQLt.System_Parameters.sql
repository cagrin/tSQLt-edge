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
	DECLARE @Command NVARCHAR(MAX) =
	'SELECT
		[object_id],
		[name],
		[parameter_id],
		[system_type_id],
		[user_type_id],
		[max_length],
		[precision],
		[scale],
		[is_output],
		[is_cursor_ref],
		[has_default_value],
		[is_xml_document],
		[default_value],
		[xml_collection_id],
		[is_readonly],
		[is_nullable],
		[encryption_type],
		[encryption_type_desc],
		[encryption_algorithm_name],
		[column_encryption_key_id],
		[column_encryption_key_database_name]
	FROM sys.parameters
	WHERE object_id = OBJECT_ID(@ObjectName)'

	DECLARE @DatabaseName NVARCHAR(MAX) = QUOTENAME(PARSENAME(@ObjectName, 3))
	IF @DatabaseName IS NOT NULL
	BEGIN
		SET @Command = CONCAT
		(
			'EXEC(''USE ', @DatabaseName, '; ',
            'DECLARE @ObjectName NVARCHAR(MAX) = ''''', @ObjectName, '''''; ',
			'EXEC sys.sp_executesql N''''', REPLACE(@Command, '''', ''''''''''), ''''', N''''@ObjectName NVARCHAR(MAX)'''', @ObjectName;'')'
		)
	END

	EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX)', @ObjectName;
END;
GO