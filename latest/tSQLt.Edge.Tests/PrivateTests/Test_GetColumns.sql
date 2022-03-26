CREATE SCHEMA Test_GetColumns;
GO

CREATE PROCEDURE Test_GetColumns.Test_DataTypes
AS
BEGIN
    DECLARE @Actual NVARCHAR(MAX) = REPLACE(tSQLt.Private_GetColumns('dbo.TestTable'), ', [', CONCAT(',', NCHAR(10), '['));

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