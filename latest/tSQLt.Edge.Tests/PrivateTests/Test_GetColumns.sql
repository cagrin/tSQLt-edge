CREATE SCHEMA Test_GetColumns;
GO

CREATE PROCEDURE Test_GetColumns.Test_DataTypes
AS
BEGIN
    -- https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver15
    CREATE TABLE dbo.TestTable
    (
        [col1] bigint,
        [col2] bit,
        [col3] decimal(16,2),
        [col4] int,
        [col5] money,
        [col6] numeric(16,2),
        [col7] smallint,
        [col8] tinyint,
        [col9] float,
        [col10] real,
        [col11] date,
        [col12] datetime2(3),
        [col13] datetime,
        [col14] datetimeoffset(3),
        [col15] smalldatetime,
        [col16] time(3),
        [col17] char(10),
        [col18] text,
        [col19] varchar(10),
        [col20] varchar(max),
        [col21] nchar(10),
        [col22] ntext,
        [col23] varchar(10),
        [col24] varchar(max),
        [col25] binary(10),
        [col26] image,
        [col27] varbinary(10),
        [col28] varbinary(max),
        [col29] rowversion,
        [col30] uniqueidentifier,
        [col31] xml
    );

    DECLARE @Actual NVARCHAR(MAX);
    EXEC tSQLt.Private_GetColumns @Actual OUTPUT, 'dbo.TestTable';
    SET @Actual = REPLACE(@Actual, ', [', CONCAT(',', NCHAR(10), '['));

    DECLARE @Expected NVARCHAR(MAX) =
'[col1] bigint NULL,
[col2] bit NULL,
[col3] decimal(16,2) NULL,
[col4] int NULL,
[col5] money NULL,
[col6] numeric(16,2) NULL,
[col7] smallint NULL,
[col8] tinyint NULL,
[col9] float NULL,
[col10] real NULL,
[col11] date NULL,
[col12] datetime2(3) NULL,
[col13] datetime NULL,
[col14] datetimeoffset(3) NULL,
[col15] smalldatetime NULL,
[col16] time(3) NULL,
[col17] char(10) NULL,
[col18] text NULL,
[col19] varchar(10) NULL,
[col20] varchar(max) NULL,
[col21] nchar(10) NULL,
[col22] ntext NULL,
[col23] varchar(10) NULL,
[col24] varchar(max) NULL,
[col25] binary(10) NULL,
[col26] image NULL,
[col27] varbinary(10) NULL,
[col28] varbinary(max) NULL,
[col29] timestamp NOT NULL,
[col30] uniqueidentifier NULL,
[col31] xml NULL';

    EXEC tSQLt.AssertEqualsString @Expected, @Actual;
END;
GO