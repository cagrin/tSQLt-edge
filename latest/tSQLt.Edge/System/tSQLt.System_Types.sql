CREATE TYPE tSQLt.System_TypesType AS TABLE
(
	[name] [sysname] NOT NULL,
	[system_type_id] [tinyint] NOT NULL,
	[user_type_id] [int] NOT NULL,
	[schema_name] [sysname] NOT NULL,
	[principal_id] [int] NULL,
	[max_length] [smallint] NOT NULL,
	[precision] [tinyint] NOT NULL,
	[scale] [tinyint] NOT NULL,
	[collation_name] [sysname] NULL,
	[is_nullable] [bit] NULL,
	[is_user_defined] [bit] NOT NULL,
	[is_assembly_type] [bit] NOT NULL,
	[default_object_id] [int] NOT NULL,
	[rule_object_id] [int] NOT NULL,
	[is_table_type] [bit] NOT NULL
);
GO

CREATE PROCEDURE tSQLt.System_Types
	@ObjectName NVARCHAR(MAX),
	@TypeId INT
AS
BEGIN
	DECLARE @Command NVARCHAR(MAX) =
	'SELECT
		[name],
		[system_type_id],
		[user_type_id],
		[schema_name] = SCHEMA_NAME(schema_id),
		[principal_id],
		[max_length],
		[precision],
		[scale],
		[collation_name],
		[is_nullable],
		[is_user_defined],
		[is_assembly_type],
		[default_object_id],
		[rule_object_id],
		[is_table_type]
	FROM sys.types
	WHERE user_type_id = @TypeId'

	DECLARE @DatabaseName NVARCHAR(MAX) = QUOTENAME(PARSENAME(@ObjectName, 3))
	IF @DatabaseName IS NOT NULL
	BEGIN
		DECLARE @Execute NVARCHAR(MAX) = CONCAT
		(
			'USE ', @DatabaseName, '; ',
			'EXEC sys.sp_executesql @Command, N''@TypeId INT'', @TypeId;'
		)

		EXEC sys.sp_executesql @Execute, N'@Command NVARCHAR(MAX), @TypeId INT', @Command, @TypeId;
	END
	ELSE
	BEGIN
		EXEC sys.sp_executesql @Command, N'@TypeId INT', @TypeId;
	END
END;
GO