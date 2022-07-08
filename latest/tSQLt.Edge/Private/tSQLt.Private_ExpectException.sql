CREATE TABLE tSQLt.Private_ExpectException
(
    ExpectException BIT NOT NULL,
    ExpectedMessage NVARCHAR(MAX),
    ExpectedSeverity INT,
    ExpectedState INT,
    Message NVARCHAR(MAX),
    ExpectedMessagePattern NVARCHAR(MAX),
    ExpectedErrorNumber INT
);