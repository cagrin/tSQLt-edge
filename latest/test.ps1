$Collation='Polish_CI_AS'
$SA_PASSWORD='StrongP@ssw0rd!'
$DB_NAME='tSQLt-edge'

docker container stop test_image
docker container rm test_image
docker run --name test_image -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=$SA_PASSWORD" -e "MSSQL_COLLATION=$Collation" -p 51433:1433 -d mcr.microsoft.com/azure-sql-edge
Start-Sleep -Second 30

dotnet publish ./Tests /p:TargetServerName=localhost /p:TargetPort=51433 /p:TargetDatabaseName=$DB_NAME /p:TargetUser=sa /p:TargetPassword=$SA_PASSWORD

Invoke-Sqlcmd -ServerInstance "localhost,51433" -Database "$DB_NAME" -Username "sa" -Password "$SA_PASSWORD" -Query "EXEC testAPI.RunAll" -Verbose

docker container stop test_image
docker container rm test_image