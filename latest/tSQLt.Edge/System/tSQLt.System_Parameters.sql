CREATE FUNCTION tSQLt.System_Parameters (@ObjectId INT)
RETURNS @Parameters TABLE
(
	[object_id] [int] NOT NULL,
	[name] [sysname] NULL,
	[parameter_id] [int] NOT NULL,
	[system_type_id] [tinyint] NOT NULL,
	[user_type_id] [int] NOT NULL,
	[max_length] [smallint] NOT NULL,
	[precision] [tinyint] NOT NULL,
	[scale] [tinyint] NOT NULL,
	[is_output] [bit] NOT NULL,
	[is_cursor_ref] [bit] NOT NULL,
	[has_default_value] [bit] NOT NULL,
	[is_xml_document] [bit] NOT NULL,
	[default_value] [sql_variant] NULL,
	[xml_collection_id] [int] NOT NULL,
	[is_readonly] [bit] NOT NULL,
	[is_nullable] [bit] NULL,
	[encryption_type] [int] NULL,
	[encryption_type_desc] [nvarchar](64) NULL,
	[encryption_algorithm_name] [sysname] NULL,
	[column_encryption_key_id] [int] NULL,
	[column_encryption_key_database_name] [sysname] NULL
) AS
BEGIN
	INSERT INTO @Parameters
    SELECT * FROM sys.parameters
    WHERE object_id = @ObjectId

    RETURN;
END;
GO