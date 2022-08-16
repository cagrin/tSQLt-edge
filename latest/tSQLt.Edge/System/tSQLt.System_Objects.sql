CREATE TYPE tSQLt.System_ObjectsType AS TABLE
(
	[name] [sysname] NOT NULL,
	[object_id] [int] NOT NULL,
	[principal_id] [int] NULL,
	[schema_id] [int] NOT NULL,
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
	@ObjectName NVARCHAR(MAX) = NULL
AS
BEGIN
	EXEC tSQLt.System_Table
		@SysTableType = 'System_ObjectsType',
		@SysTableName = 'sys.objects',
		@ObjectName = @ObjectName
END;
GO