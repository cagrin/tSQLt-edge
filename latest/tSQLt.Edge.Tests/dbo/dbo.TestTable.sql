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
GO

CREATE TABLE dbo.FakeDataSource (Column1 int);
GO