CREATE FUNCTION tSQLt.System_Tests (@TestName NVARCHAR(MAX))
RETURNS @Tests TABLE
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
) AS
BEGIN
	INSERT INTO @Tests
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
	FROM sys.procedures r
	WHERE r.name LIKE 'test%'
	AND SCHEMA_NAME(r.schema_id) <> 'tSQLt'
	AND NOT EXISTS (SELECT 1 FROM sys.parameters p WHERE p.object_id = r.object_id)
	AND
	(
		@TestName IS NULL
		OR @TestName = QUOTENAME(SCHEMA_NAME(r.schema_id))
		OR @Testname = CONCAT(QUOTENAME(SCHEMA_NAME(r.schema_id)), '.', QUOTENAME(r.name))
	)

    RETURN;
END;
GO