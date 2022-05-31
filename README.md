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
- Use tSQLt assertions in internal tests

## Compatibility
[tSQLt-edge](https://www.nuget.org/packages/tSQLt.Edge) is mostly fully compatible with tSQLt unit testing framework. See [full user guide](https://tsqlt.org/full-user-guide/) for more details about tSQLt.

> The default method of calling tSQLt.NewTestClass to create a tSQLt test class (the schema to organize your unit tests) does not work either in Visual Studio database projects nor MSBuild.SDK.SqlProj projects. That is why tSQLt-edge entirely drop support for NewTestClass, DropClass and RenameClass.

||Status|
|--- |---|
|![](https://img.shields.io/badge/--green)|Fully compatible|
|![](https://img.shields.io/badge/--yellow)|Large or partial support|
|![](https://img.shields.io/badge/--red)|Unsupported|

#### Test creation and execution:

- ![](https://img.shields.io/badge/DropClass--red)
- ![](https://img.shields.io/badge/NewTestClass--red)
- ![](https://img.shields.io/badge/RenameClass--red)
- ![](https://img.shields.io/badge/Run--yellow)
- ![](https://img.shields.io/badge/RunAll--yellow)
- ![](https://img.shields.io/badge/TestCaseSummary--green)
- ![](https://img.shields.io/badge/TestClasses--green)
- ![](https://img.shields.io/badge/TestResult--green)
- ![](https://img.shields.io/badge/Tests--green)
- ![](https://img.shields.io/badge/XmlResultFormatter--red)

#### Assertions:

- ![](https://img.shields.io/badge/AssertEmptyTable--green)
- ![](https://img.shields.io/badge/AssertEquals--green)
- ![](https://img.shields.io/badge/AssertEqualsString--green)
- ![](https://img.shields.io/badge/AssertEqualsTable--yellow)
- ![](https://img.shields.io/badge/AssertEqualsTableSchema--green)
- ![](https://img.shields.io/badge/AssertLike--green)
- ![](https://img.shields.io/badge/AssertNotEquals--green)
- ![](https://img.shields.io/badge/AssertObjectDoesNotExist--green)
- ![](https://img.shields.io/badge/AssertObjectExists--green)
- ![](https://img.shields.io/badge/AssertResultSetsHaveSameMetaData--yellow)
- ![](https://img.shields.io/badge/AssertStringIn--green)
- ![](https://img.shields.io/badge/Fail--green)

#### Expectations:

- ![](https://img.shields.io/badge/ExpectException--green)
- ![](https://img.shields.io/badge/ExpectNoException--green)

#### Isolating dependencies:

- ![](https://img.shields.io/badge/ApplyConstraint--red)
- ![](https://img.shields.io/badge/ApplyTrigger--red)
- ![](https://img.shields.io/badge/FakeFunction--yellow)
- ![](https://img.shields.io/badge/FakeTable--yellow)
- ![](https://img.shields.io/badge/RemoveObject--green)
- ![](https://img.shields.io/badge/RemoveObjectIfExists--green)
- ![](https://img.shields.io/badge/SpyProcedure--yellow)

## Extentions

tSQLt-edge has some additional stored procedures:

|Name|Description|
|--- |---|
|AssertNotEqualsString|Same as AssertNotEquals, but for NVARCHAR(MAX)|