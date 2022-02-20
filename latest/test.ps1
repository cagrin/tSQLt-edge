param ([int] $retest)

$SA_PASSWORD='A.794613'
$Collation='Polish_CI_AS'

if ($retest -ne 1)
{
    docker container stop test_image
    docker container rm test_image
    docker run --name test_image -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=$SA_PASSWORD" -e "MSSQL_COLLATION=$Collation" -p 51433:1433 -d mcr.microsoft.com/azure-sql-edge
    Start-Sleep -Second 30

    $TEST_NAME='tSQLt.API.Tests'
    dotnet publish ./$TEST_NAME /p:TargetServerName=localhost /p:TargetPort=51433 /p:TargetDatabaseName=$TEST_NAME /p:TargetUser=sa /p:TargetPassword=$SA_PASSWORD
    Invoke-Sqlcmd -ServerInstance "localhost,51433" -Database "$TEST_NAME" -Username "sa" -Password "$SA_PASSWORD" -Query "EXEC tSQLt.RunAll" -Verbose
}

$TEST_NAME='tSQLt.Edge.Tests'
dotnet publish ./$TEST_NAME /p:TargetServerName=localhost /p:TargetPort=51433 /p:TargetDatabaseName=$TEST_NAME /p:TargetUser=sa /p:TargetPassword=$SA_PASSWORD
Invoke-Sqlcmd -ServerInstance "localhost,51433" -Database "$TEST_NAME" -Username "sa" -Password "$SA_PASSWORD" -Query "EXEC tSQLt.RunAll" -Verbose