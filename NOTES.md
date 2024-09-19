## Run unit tests on Dev Container
```
git submodule update --init
sqltest runall --image mcr.microsoft.com/mssql/server:2019-latest --project ./latest/tSQLt.Edge.Tests --cc-include-tsqlt
sqltest runall --image mcr.microsoft.com/mssql/server:2019-latest --project ./latest/tSQLt.Edge.Tests.CaseSensitive --cc-include-tsqlt
sqltest runall --image mcr.microsoft.com/mssql/server:2019-latest --project ./latest/tSQLt.Original.Tests --cc-disable
sqltest runall --image mcr.microsoft.com/mssql/server:2019-latest --project ./current/Example.Tests
dotnet test ./latest/tSQLt.XmlResult.Tests
sqltest runall --image mcr.microsoft.com/mssql/server:2019-latest --project ./legacy/tSQLt.Unoriginal.Tests --cc-disable
sqltest runall --image mcr.microsoft.com/mssql/server:2019-latest --project ./legacy/Example.Tests
```