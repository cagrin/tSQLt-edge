CREATE TYPE tSQLt.System_CheckConstraintsType AS TABLE
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
		[is_schema_published],
		[is_disabled],
		[is_not_for_replication],
		[is_not_trusted],
		[parent_column_id],
		[definition],
		[uses_database_collation],
		[is_system_named]
	FROM sys.check_constraints
	WHERE object_id = @ConstraintId'

	DECLARE @DatabaseName NVARCHAR(MAX) = QUOTENAME(PARSENAME(@ObjectName, 3))
	IF @DatabaseName IS NOT NULL
	BEGIN
		SET @Command = CONCAT
		(
			'EXEC(''USE ', @DatabaseName, '; ',
            'DECLARE @ConstraintId INT = ', @ConstraintId, '; ',
			'EXEC sys.sp_executesql N''''', REPLACE(@Command, '''', ''''''''''), ''''', N''''@ConstraintId INT'''', @ConstraintId;'')'
		)
	END

	EXEC sys.sp_executesql @Command, N'@ConstraintId INT', @ConstraintId;
END;
GO