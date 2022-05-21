CREATE SCHEMA Test_XmlResultFormatter;
GO

CREATE PROCEDURE Test_XmlResultFormatter.Test_IsUnsupported
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.XmlResultFormatter is not yet supported.'

    EXEC tSQLt.XmlResultFormatter;
END;
GO