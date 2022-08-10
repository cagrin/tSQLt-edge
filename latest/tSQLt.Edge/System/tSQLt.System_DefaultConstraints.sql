CREATE TYPE tSQLt.System_DefaultConstraintsType AS TABLE
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
	DECLARE @DefaultConstraints tSQLt.System_DefaultConstraintsType;

    INSERT INTO @DefaultConstraints
    SELECT
		[name],
		[object_id],
		[principal_id],
		[schema_id],
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
    WHERE parent_object_id = OBJECT_ID(@ObjectName) AND parent_column_id = @ColumnId
    UNION ALL
    SELECT
		[name],
		[object_id],
		[principal_id],
		[schema_id],
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
	FROM tempdb.sys.default_constraints
    WHERE parent_object_id = OBJECT_ID(CONCAT('tempdb..', @ObjectName)) AND parent_column_id = @ColumnId

    SELECT * FROM @DefaultConstraints
END;
GO