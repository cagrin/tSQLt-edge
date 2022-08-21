CREATE TYPE tSQLt.System_SqlModulesType AS TABLE
(
	[object_id] [int] NOT NULL,
	[definition] [nvarchar](max) NULL,
	[uses_ansi_nulls] [bit] NULL,
	[uses_quoted_identifier] [bit] NULL,
	[is_schema_bound] [bit] NULL,
	[uses_database_collation] [bit] NULL,
	[is_recompiled] [bit] NULL,
	[null_on_null_input] [bit] NULL,
	[execute_as_principal_id] [int] NULL,
	[uses_native_compilation] [bit] NULL,
	[inline_type] [bit] NULL,
	[is_inlineable] [bit] NULL
);
GO

CREATE PROCEDURE tSQLt.System_SqlModules
	@ObjectName NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Command NVARCHAR(MAX) =
	'SELECT
		[object_id],
		[definition],
		[uses_ansi_nulls],
		[uses_quoted_identifier],
		[is_schema_bound],
		[uses_database_collation],
		[is_recompiled],
		[null_on_null_input],
		[execute_as_principal_id],
		[uses_native_compilation],
		[inline_type],
		[is_inlineable]
	FROM sys.sql_modules
	WHERE object_id = OBJECT_ID(@ObjectName)'

	DECLARE @DatabaseName NVARCHAR(MAX) = QUOTENAME(PARSENAME(@ObjectName, 3))
	IF @DatabaseName IS NOT NULL
	BEGIN
		DECLARE @Execute NVARCHAR(MAX) = CONCAT
		(
			'USE ', @DatabaseName, '; ',
			'EXEC sys.sp_executesql @Command, N''@ObjectName NVARCHAR(MAX)'', @ObjectName;'
		)

		EXEC sys.sp_executesql @Execute, N'@Command NVARCHAR(MAX), @ObjectName NVARCHAR(MAX)', @Command, @ObjectName;
	END
	ELSE
	BEGIN
		EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX)', @ObjectName;
	END
END;
GO