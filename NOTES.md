## Create Azure SQL Edge instance in docker
```
docker run -e 'ACCEPT_EULA=1' -e 'MSSQL_SA_PASSWORD=StrongP@ssw0rd!' -e 'MSSQL_COLLATION=Polish_CI_AS' -p 1433:1433 -d mcr.microsoft.com/azure-sql-edge
```

## Build and publish project Tests to localhost
```
dotnet publish ./Tests /p:TargetServerName=localhost /p:TargetDatabaseName=tSQLt-edge /p:TargetUser=sa /p:TargetPassword=StrongP@ssw0rd!
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
Invoke-Sqlcmd -Query "EXEC testSchema.test1" -ServerInstance localhost -Database tSQLt-edge -Username sa -Password StrongP@ssw0rd! -Verbose
```