CREATE VIEW tSQLt.TestClasses
AS
    SELECT DISTINCT
        [Name] = ISNULL(CAST(SCHEMA_NAME(s.schema_id) AS SYSNAME), ''),
        [SchemaId] = s.schema_id
    FROM tSQLt.System_Tests (NULL) s
GO