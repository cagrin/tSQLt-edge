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

## Compatibility
[tSQLt-edge 0.3.0](https://www.nuget.org/packages/tSQLt.Edge/0.3.0) is partially compatible with tSQLt unit testing framework. See [full user guide](https://tsqlt.org/full-user-guide/) for more details about tSQLt.

||Status|
|--- |---|
|![](https://img.shields.io/badge/--green)|Fully compatible|
|![](https://img.shields.io/badge/--yellow)|Initial support|
|![](https://img.shields.io/badge/--red)|Not implemented|

#### Test creation and execution:

- ![](https://img.shields.io/badge/NewTestClass--red)
- ![](https://img.shields.io/badge/DropClass--red)
- ![](https://img.shields.io/badge/RunAll--yellow)
- ![](https://img.shields.io/badge/Run--green)
- ![](https://img.shields.io/badge/RenameClass--red)

#### Assertions:

- ![](https://img.shields.io/badge/AssertEmptyTable--red)
- ![](https://img.shields.io/badge/AssertEquals--green)
- ![](https://img.shields.io/badge/AssertEqualsString--green)
- ![](https://img.shields.io/badge/AssertEqualsTable--green)
- ![](https://img.shields.io/badge/AssertEqualsTableSchema--green)
- ![](https://img.shields.io/badge/AssertNotEquals--green)
- ![](https://img.shields.io/badge/AssertObjectDoesNotExist--green)
- ![](https://img.shields.io/badge/AssertObjectExists--green)
- ![](https://img.shields.io/badge/AssertResultSetsHaveSameMetaData--green)
- ![](https://img.shields.io/badge/Fail--green)
- ![](https://img.shields.io/badge/AssertLike--red)

#### Expectations:

- ![](https://img.shields.io/badge/ExpectException--green)
- ![](https://img.shields.io/badge/ExpectNoException--red)

#### Isolating dependencies:

- ![](https://img.shields.io/badge/ApplyConstraint--red)
- ![](https://img.shields.io/badge/FakeFunction--red)
- ![](https://img.shields.io/badge/FakeTable--red)
- ![](https://img.shields.io/badge/RemoveObjectIfExists--red)
- ![](https://img.shields.io/badge/SpyProcedure--green)
- ![](https://img.shields.io/badge/ApplyTrigger--red)
- ![](https://img.shields.io/badge/RemoveObject--red)