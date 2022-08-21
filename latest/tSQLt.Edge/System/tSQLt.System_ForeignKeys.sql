CREATE TYPE tSQLt.System_ForeignKeysType AS TABLE
(
	[object_id] [int] NOT NULL,
	[schema_name] [sysname] NOT NULL,
	[parent_object_id] [int] NOT NULL,
	[name] [sysname] NOT NULL,
	[update_referential_action_desc] [nvarchar](60) NULL,
	[delete_referential_action_desc] [nvarchar](60) NULL,
	[foreign_key_columns] [nvarchar](MAX) NOT NULL,
	[referenced_object_id] [int] NOT NULL,
	[referenced_schema_name] [sysname] NOT NULL,
	[referenced_name] [sysname] NOT NULL,
	[referenced_columns] [nvarchar](MAX) NOT NULL
);
GO

CREATE PROCEDURE tSQLt.System_ForeignKeys
	@ObjectName NVARCHAR(MAX),
	@ConstraintId INT
AS
BEGIN
	DECLARE @Command NVARCHAR(MAX) =
	'SELECT
		fk.object_id,
		schema_name = SCHEMA_NAME(fk.schema_id),
		fk.parent_object_id,
		fk.name,
		fk.update_referential_action_desc,
		fk.delete_referential_action_desc,
		foreign_key_columns =
		(
			SELECT STRING_AGG(QUOTENAME(pci.name), '', '')
			FROM sys.foreign_key_columns c
			INNER JOIN sys.columns pci
			ON pci.object_id = c.parent_object_id
			AND pci.column_id = c.parent_column_id
			WHERE fk.object_id = c.constraint_object_id
		),
		referenced_object_id = t.object_id,
		referenced_schema_name = SCHEMA_NAME(t.schema_id),
		referenced_name = t.name,
		referenced_columns =
		(
			SELECT STRING_AGG(QUOTENAME(rci.name), '', '')
			FROM sys.foreign_key_columns c
			INNER JOIN sys.columns rci
			ON rci.object_id = c.referenced_object_id
			AND rci.column_id = c.referenced_column_id
			WHERE fk.object_id = c.constraint_object_id
		)
	FROM sys.foreign_keys fk
	INNER JOIN sys.tables t ON fk.referenced_object_id = t.object_id
	WHERE fk.object_id = @ConstraintId'

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