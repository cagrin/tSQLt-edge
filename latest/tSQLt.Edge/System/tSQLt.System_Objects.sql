CREATE FUNCTION tSQLt.System_Objects ()
RETURNS @Objects TABLE
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
) AS
BEGIN
    INSERT INTO @Objects
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
		[is_schema_published]
	FROM sys.objects

    RETURN;
END;
GO