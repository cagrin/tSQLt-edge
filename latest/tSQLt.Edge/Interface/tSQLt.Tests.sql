CREATE VIEW tSQLt.Tests
AS
    SELECT
	    [SchemaId] = s.schema_id,
        [TestClassName] = ISNULL(CAST(SCHEMA_NAME(s.schema_id) AS SYSNAME), ''),
        [ObjectId] = s.object_id,
       	[Name] = s.name
    FROM tSQLt.System_Tests (NULL) s
GO