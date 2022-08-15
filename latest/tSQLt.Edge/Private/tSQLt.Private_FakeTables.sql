CREATE TABLE tSQLt.Private_FakeTables
(
    ObjectId INT NOT NULL,
    ObjectName NVARCHAR(MAX) NOT NULL,
    FakeObjectId INT NOT NULL,
    FakeObjectName NVARCHAR(MAX) NOT NULL,
    CONSTRAINT [PK__tSQLt_Private_FakeTables] PRIMARY KEY CLUSTERED (ObjectId, FakeObjectId)
)