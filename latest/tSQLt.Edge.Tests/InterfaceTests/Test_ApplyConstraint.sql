CREATE SCHEMA Test_ApplyConstraint;
GO

CREATE PROCEDURE Test_ApplyConstraint.Test_IsUnsupported
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.ApplyConstraint is not yet supported.'

    EXEC tSQLt.ApplyConstraint 'TableName1', 'ConstraintName1';
END;
GO