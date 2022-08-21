CREATE TYPE tSQLt.System_SynonymsType AS TABLE
(
	[name] [sysname] NOT NULL,
	[object_id] [int] NOT NULL,
	[principal_id] [int] NULL,
	[schema_name] [sysname] NOT NULL,
	[parent_object_id] [int] NOT NULL,
	[type] [char](2) NULL,
	[type_desc] [nvarchar](60) NULL,
	[create_date] [datetime] NOT NULL,
	[modify_date] [datetime] NOT NULL,
	[is_ms_shipped] [bit] NOT NULL,
	[is_published] [bit] NOT NULL,
	[is_schema_published] [bit] NOT NULL,
	[base_object_name] [nvarchar](1035) NULL
);
GO

CREATE PROCEDURE tSQLt.System_Synonyms
	@ObjectName NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Command NVARCHAR(MAX) =
	'SELECT
		[name],
		[object_id],
		[principal_id],
		[schema_name] = SCHEMA_NAME(schema_id),
		[parent_object_id],
		[type],
		[type_desc],
		[create_date],
		[modify_date],
		[is_ms_shipped],
		[is_published],
		[is_schema_published],
		[base_object_name]
	FROM sys.synonyms
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