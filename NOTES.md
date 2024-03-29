## Create Azure SQL Edge instance in docker
```
docker run -e 'ACCEPT_EULA=1' -e 'MSSQL_SA_PASSWORD=A.794613' -e 'MSSQL_COLLATION=SQL_Latin1_General_CP1_CI_AS' -p 51433:1433 -d mcr.microsoft.com/azure-sql-edge
```

## Build and publish project Tests to localhost
```
dotnet publish ./latest/tSQLt.Edge.Tests /p:TargetServerName=localhost /p:TargetPort=51433 /p:TargetDatabaseName=tSQLt.Edge.Tests /p:TargetUser=sa /p:TargetPassword=A.794613
```

## Prepare Powershell (optional)
```
pwsh
Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module -Name SqlServer
```

## Run unit tests in Powershell
```
pwsh
Invoke-Sqlcmd -Query "EXEC tSQLt.RunAll" -ServerInstance "localhost,51433" -Database "tSQLt.Edge.Tests" -Username "sa" -Password "A.794613"
```

## Run unit tests on Dev Container
```
git submodule update --init
sqltest runall --image mcr.microsoft.com/azure-sql-edge --project ./latest/tSQLt.Edge.Tests --cc-include-tsqlt
sqltest runall --image mcr.microsoft.com/azure-sql-edge --project ./latest/tSQLt.Edge.Tests.CaseSensitive --cc-include-tsqlt
sqltest runall --image mcr.microsoft.com/azure-sql-edge --project ./latest/tSQLt.Original.Tests --cc-disable
sqltest runall --image mcr.microsoft.com/azure-sql-edge --project ./current/Example.Tests
dotnet test ./latest/tSQLt.XmlResult.Tests
sqltest runall --image mcr.microsoft.com/mssql/server:2019-latest --project ./legacy/tSQLt.Unoriginal.Tests --cc-disable
sqltest runall --image mcr.microsoft.com/mssql/server:2019-latest --project ./legacy/Example.Tests
```