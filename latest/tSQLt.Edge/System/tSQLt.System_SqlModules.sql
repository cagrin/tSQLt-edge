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
	@ObjectName NVARCHAR(MAX) = NULL
AS
BEGIN
	EXEC tSQLt.System_Table
		@SysTableType = 'System_SqlModulesType',
		@SysTableName = 'sys.sql_modules',
		@ObjectName = @ObjectName
END;
GO