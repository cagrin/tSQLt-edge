CREATE TYPE tSQLt.System_InterfacesType AS TABLE
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
	[is_auto_executed] [bit] NOT NULL,
	[is_execution_replicated] [bit] NULL,
	[is_repl_serializable_only] [bit] NULL,
	[skips_repl_constraints] [bit] NULL
);
GO

CREATE PROCEDURE tSQLt.System_Interfaces
AS
BEGIN
	DECLARE @Interfaces tSQLt.System_InterfacesType;

	INSERT INTO @Interfaces
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
		[is_auto_executed],
		[is_execution_replicated],
		[is_repl_serializable_only],
		[skips_repl_constraints]
	FROM sys.procedures
    WHERE SCHEMA_NAME(schema_id) = 'tSQLt'
    AND name NOT LIKE 'Internal[_]%'
    AND name NOT LIKE 'Private[_]%'
    AND name NOT LIKE 'System[_]%'
    AND name <> 'RunAll'

    SELECT * FROM @Interfaces
END;
GO