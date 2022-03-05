[![NuGet](https://img.shields.io/nuget/v/tSQLt.Edge)](https://www.nuget.org/packages/tSQLt.Edge)
[![Nuget](https://img.shields.io/nuget/dt/tSQLt.Edge)](https://www.nuget.org/stats/packages/tSQLt.Edge?groupby=Version)

# tSQLt-edge
tSQLt-compatible unit testing framework for Azure SQL Edge.

## Description
This project was created in order to practice code writing in TDD. When it is finished, it should contain the vast majority of the tSQLt framework functionalities written for Azure SQL Edge and based on the MSBuild.SDK.SqlProj project format.

Detailed principles:
- Use modern Sql150 syntax
- Include nuget package
- No CLR code
- Use CONCAT, CONCAT_WS instead of adding strings (+)
- Use STRING_AGG instead of concatenate strings with FOR XML PATH