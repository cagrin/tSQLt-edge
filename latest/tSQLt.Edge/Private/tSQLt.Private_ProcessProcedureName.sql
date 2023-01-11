CREATE PROCEDURE tSQLt.Private_ProcessProcedureName
    @ProcedureName NVARCHAR(MAX),
    @Parameters NVARCHAR(MAX) OUTPUT,
    @ParametersNames NVARCHAR(MAX) OUTPUT,
    @SpyProcedureLogSelect NVARCHAR(MAX) OUTPUT,
    @SpyProcedureLogColumns NVARCHAR(MAX) OUTPUT,
    @ParametersWithTypesDefaultNulls NVARCHAR(MAX) OUTPUT
AS
BEGIN
    DECLARE @ObjectType CHAR(2);
    EXEC tSQLt.Private_GetObjectType @ObjectType OUTPUT, @ProcedureName;

    IF @ObjectType IS NULL OR @ObjectType NOT IN ('P')
    BEGIN
        EXEC tSQLt.Fail 'Cannot use SpyProcedure on', @ProcedureName, 'because the procedure does not exist.';
    END

    EXEC tSQLt.Private_GetParameters @Parameters OUTPUT, @ProcedureName;
    EXEC tSQLt.Private_GetParametersNames @ParametersNames OUTPUT, @ProcedureName;
    EXEC tSQLt.Private_GetSpyProcedureLogSelect @SpyProcedureLogSelect OUTPUT, @ProcedureName;
    EXEC tSQLt.Private_GetSpyProcedureLogColumns @SpyProcedureLogColumns OUTPUT, @ProcedureName;
    EXEC tSQLt.Private_GetParametersWithTypes @ParametersWithTypesDefaultNulls OUTPUT, @ProcedureName, @DefaultNulls = 1;
END;
GO