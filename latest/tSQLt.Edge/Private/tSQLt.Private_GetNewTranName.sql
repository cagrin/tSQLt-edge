CREATE PROCEDURE tSQLt.Private_GetNewTranName
    @TranName CHAR(32) OUTPUT
AS
BEGIN
    SELECT @TranName = LEFT(CONCAT('tSQLtTran', REPLACE(CAST(NEWID() AS CHAR(36)), '-' , '')), 32);
END;
GO