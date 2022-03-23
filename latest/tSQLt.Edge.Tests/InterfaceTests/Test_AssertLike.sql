CREATE SCHEMA Test_AssertLike;
GO

CREATE PROCEDURE Test_AssertLike.Test_HelloHello
AS
BEGIN
    EXEC tSQLt.AssertLike 'Hello', 'Hello';
END;
GO

CREATE PROCEDURE Test_AssertLike.Test_HelloH_llo
AS
BEGIN
    EXEC tSQLt.AssertLike 'H_llo', 'Hello';
END;
GO

CREATE PROCEDURE Test_AssertLike.Test_HelloH_o
AS
BEGIN
    EXEC tSQLt.AssertLike 'H%o', 'Hello';
END;
GO

CREATE PROCEDURE Test_AssertLike.Test_NullNull
AS
BEGIN
    EXEC tSQLt.AssertLike NULL, NULL;
END;
GO

CREATE PROCEDURE Test_AssertLike.Test_NullPattern
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertLike failed. ExpectedPattern:<(null)> but Actual:<Hello>.';

    EXEC tSQLt.AssertLike NULL, 'Hello';
END;
GO

CREATE PROCEDURE Test_AssertLike.Test_ErrorMessage
AS
BEGIN
    EXEC tSQLt.ExpectException 'Error message. tSQLt.AssertLike failed. ExpectedPattern:<(null)> but Actual:<Hello>.';

    EXEC tSQLt.AssertLike NULL, 'Hello', 'Error message.';
END;
GO

CREATE PROCEDURE Test_AssertLike.Test_NullH_llo
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertLike failed. ExpectedPattern:<H_llo> but Actual:<(null)>.';

    EXEC tSQLt.AssertLike 'H_llo', NULL;
END;
GO

CREATE PROCEDURE Test_AssertLike.Test_NullH_o
AS
BEGIN
    EXEC tSQLt.ExpectException 'tSQLt.AssertLike failed. ExpectedPattern:<H%o> but Actual:<(null)>.';

    EXEC tSQLt.AssertLike 'H%o', NULL;
END;
GO