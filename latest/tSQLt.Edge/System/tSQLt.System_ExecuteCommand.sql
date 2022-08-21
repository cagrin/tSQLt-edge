CREATE PROCEDURE tSQLt.System_ExecuteCommand
	@Command NVARCHAR(MAX),
	@ObjectName NVARCHAR(MAX)
AS
BEGIN
	DECLARE @DatabaseName NVARCHAR(MAX) = QUOTENAME(PARSENAME(@ObjectName, 3))
	IF @DatabaseName IS NOT NULL
	BEGIN
		DECLARE @Execute NVARCHAR(MAX) = CONCAT
		(
			'USE ', @DatabaseName, '; ',
			'EXEC sys.sp_executesql @Command, N''@ObjectName NVARCHAR(MAX)'', @ObjectName;'
		)

		EXEC sys.sp_executesql @Execute, N'@Command NVARCHAR(MAX), @ObjectName NVARCHAR(MAX)', @Command, @ObjectName;
	END
	ELSE
	BEGIN
		EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX)', @ObjectName;
	END
END;
GO

CREATE PROCEDURE tSQLt.System_ExecuteCommand_ColumnId
	@Command NVARCHAR(MAX),
	@ObjectName NVARCHAR(MAX),
	@Columnid INT
AS
BEGIN
	DECLARE @DatabaseName NVARCHAR(MAX) = QUOTENAME(PARSENAME(@ObjectName, 3))
	IF @DatabaseName IS NOT NULL
	BEGIN
		DECLARE @Execute NVARCHAR(MAX) = CONCAT
		(
			'USE ', @DatabaseName, '; ',
			'EXEC sys.sp_executesql @Command, N''@ObjectName NVARCHAR(MAX), @ColumnId INT'', @ObjectName, @ColumnId;'
		)

		EXEC sys.sp_executesql @Execute, N'@Command NVARCHAR(MAX), @ObjectName NVARCHAR(MAX), @ColumnId INT', @Command, @ObjectName, @ColumnId;
	END
	ELSE
	BEGIN
		EXEC sys.sp_executesql @Command, N'@ObjectName NVARCHAR(MAX), @ColumnId INT', @ObjectName, @ColumnId;
	END
END;
GO

CREATE PROCEDURE tSQLt.System_ExecuteCommand_ConstraintId
	@Command NVARCHAR(MAX),
	@ObjectName NVARCHAR(MAX),
	@ConstraintId INT
AS
BEGIN
	DECLARE @DatabaseName NVARCHAR(MAX) = QUOTENAME(PARSENAME(@ObjectName, 3))
	IF @DatabaseName IS NOT NULL
	BEGIN
		DECLARE @Execute NVARCHAR(MAX) = CONCAT
		(
			'USE ', @DatabaseName, '; ',
			'EXEC sys.sp_executesql @Command, N''@ConstraintId INT'', @ConstraintId;'
		)

		EXEC sys.sp_executesql @Execute, N'@Command NVARCHAR(MAX), @ConstraintId INT', @Command, @ConstraintId;
	END
	ELSE
	BEGIN
		EXEC sys.sp_executesql @Command, N'@ConstraintId INT', @ConstraintId;
	END
END;
GO

CREATE PROCEDURE tSQLt.System_ExecuteCommand_TypeId
	@Command NVARCHAR(MAX),
	@ObjectName NVARCHAR(MAX),
	@TypeId INT
AS
BEGIN
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