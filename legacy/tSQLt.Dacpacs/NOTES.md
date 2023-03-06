## Pack and Build legacy tSQLt dacpacs
```
pwsh
$Version = "1.0.8083.3529-preview1"
$ApiKey = "<NUGET_APIKEY>"
nuget pack *.nuspec -Version $Version
nuget push *.nupkg -ApiKey $ApiKey -Source https://api.nuget.org/v3/index.json
```

## Run unit tests Example on legacy tSQLt dacpacs
```
sqltest runall --image mcr.microsoft.com/mssql/server:2019-latest --project ./legacy/Example.Tests
```