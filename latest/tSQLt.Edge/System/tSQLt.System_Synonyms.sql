CREATE TYPE tSQLt.System_SynonymsType AS TABLE
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
	[is_schema_published] [bit] NOT NULL,
	[base_object_name] [nvarchar](1035) NULL
);
GO

CREATE PROCEDURE tSQLt.System_Synonyms
	@ObjectName NVARCHAR(MAX)
AS
BEGIN
	EXEC tSQLt.System_Table
		@SysTableType = 'System_SynonymsType',
		@SysTableName = 'sys.synonyms',
		@ObjectName = @ObjectName
END;
GO