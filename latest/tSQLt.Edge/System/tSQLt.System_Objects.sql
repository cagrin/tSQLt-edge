CREATE TYPE tSQLt.System_ObjectsType AS TABLE
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
	[is_schema_published] [bit] NOT NULL
);
GO

CREATE PROCEDURE tSQLt.System_Objects
	@ObjectName NVARCHAR(MAX),
	@ParentObjectFilter BIT = 0
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
		[is_schema_published]
	FROM sys.objects
	WHERE object_id = OBJECT_ID(@ObjectName)'

	IF @ParentObjectFilter = 1
	BEGIN
		SET @Command = REPLACE(@Command, 'WHERE object_id =', 'WHERE parent_object_id =')
	END

	EXEC tSQLt.System_ExecuteCommand @Command, @ObjectName;
END;
GO