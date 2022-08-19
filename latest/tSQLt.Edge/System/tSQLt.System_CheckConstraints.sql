CREATE TYPE tSQLt.System_CheckConstraintsType AS TABLE
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
	[is_disabled] [bit] NOT NULL,
	[is_not_for_replication] [bit] NOT NULL,
	[is_not_trusted] [bit] NOT NULL,
	[parent_column_id] [int] NOT NULL,
	[definition] [nvarchar](max) NULL,
	[uses_database_collation] [bit] NULL,
	[is_system_named] [bit] NOT NULL
);
GO

CREATE PROCEDURE tSQLt.System_CheckConstraints
	@ObjectName NVARCHAR(MAX),
	@ConstraintId INT
AS
BEGIN
	DECLARE @SourceTable NVARCHAR(MAX) = 'sys.check_constraints'
	IF PARSENAME(@ObjectName, 3) IS NOT NULL
	BEGIN
		SET @SourceTable = CONCAT(QUOTENAME(PARSENAME(@ObjectName, 3)), '.', @SourceTable)
	END

	DECLARE @TableTypeColumns NVARCHAR(MAX)
	EXEC tSQLt.System_GetTableTypeColumns @TableTypeColumns OUTPUT, @TableTypeName = 'System_CheckConstraintsType'

	DECLARE @Command NVARCHAR(MAX) = CONCAT_WS
	(
		' ',
		'SELECT', @TableTypeColumns,
		'FROM', @SourceTable,
		'WHERE object_id = @ConstraintId'
	);

	EXEC sys.sp_executesql @Command, N'@ConstraintId INT', @ConstraintId;
END;
GO