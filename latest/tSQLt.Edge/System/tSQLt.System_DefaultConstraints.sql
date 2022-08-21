CREATE TYPE tSQLt.System_DefaultConstraintsType AS TABLE
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
	[parent_column_id] [int] NOT NULL,
	[definition] [nvarchar](max) NULL,
	[is_system_named] [bit] NOT NULL
);
GO

CREATE PROCEDURE tSQLt.System_DefaultConstraints
	@ObjectName NVARCHAR(MAX),
	@ColumnId INT
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
		[parent_column_id],
		[definition],
		[is_system_named]
	FROM sys.default_constraints
	WHERE parent_object_id = OBJECT_ID(@ObjectName) AND parent_column_id = @ColumnId'

	IF OBJECT_ID(CONCAT('tempdb..', @ObjectName)) IS NOT NULL
	BEGIN
		SET @Command = REPLACE(@Command, 'FROM sys.', 'FROM tempdb.sys.')
		SET @Command = REPLACE(@Command, '@ObjectName', 'CONCAT(''tempdb..'', @ObjectName)')
	END

	DECLARE @DatabaseName NVARCHAR(MAX) = QUOTENAME(PARSENAME(@ObjectName, 3))
	IF @DatabaseName IS NOT NULL
	BEGIN
		DECLARE @Execute NVARCHAR(MAX) = CONCAT
		(
			'USE ', @DatabaseName, '; ',
			'EXEC sys.sp_executesql @Command, N''@ObjectName NVARCHAR(MAX), @ColumnId INT'', @ObjectName, @ColumnId;'
		)

		EXEC sys.sp_executesql @Execute, N'@Command NVARCHAR(MAX), @ObjectName NVARCHAR(MAX), @ColumnId INT', @Command, @ObjectName, @ColumnId;
	END
	ELSE
	BEGIN
		EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX), @ColumnId INT', @ObjectName, @ColumnId;
	END
END;
GO