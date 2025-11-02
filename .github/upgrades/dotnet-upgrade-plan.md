# .NET 8.0 Upgrade Plan

## Execution Steps

Execute steps below sequentially one by one in the order they are listed.

1. Validate that a .NET 8.0 SDK required for this upgrade is installed on the machine and if not, help to get it installed.
2. Ensure that the SDK version specified in global.json files is compatible with the .NET 8.0 upgrade.
3. Upgrade aspnetmvcapp\aspnetmvcapp.csproj

## Settings

This section contains settings and data used by execution steps.

### Aggregate NuGet packages modifications across all projects

NuGet packages used across all selected projects or their dependencies that need version update in projects that reference them.

| Package Name    | Current Version | New Version | Description       |
|:--------------------------------------------|:---------------:|:-----------:|:----------------------------------------------------------------------|
| Antlr    | 3.5.0.2         | | Replace with Antlr4 4.6.6               |
| Antlr4             |          | 4.6.6   | Replacement for Antlr           |
| Microsoft.AspNet.Mvc      | 5.2.9   |             | Package functionality included with new framework reference        |
| Microsoft.AspNet.Razor     | 3.2.9   |  | Package functionality included with new framework reference      |
| Microsoft.AspNet.Web.Optimization           | 1.1.3      || No supported version found          |
| Microsoft.AspNet.WebPages      | 3.2.9|           | Package functionality included with new framework reference           |
| Microsoft.CodeDom.Providers.DotNetCompilerPlatform | 2.0.1    |             | Package functionality included with new framework reference           |
| Microsoft.jQuery.Unobtrusive.Validation     | 3.2.11     |    | Deprecated - Replace with Microsoft.jQuery.Unobtrusive.Validation 4.0.0 |
| Microsoft.jQuery.Unobtrusive.Validation (new) |           | 4.0.0       | Replacement for deprecated Microsoft.jQuery.Unobtrusive.Validation    |
| Microsoft.Web.Infrastructure   | 2.0.0        | | Package functionality included with new framework reference           |
| Newtonsoft.Json                | 13.0.3   | 13.0.4      | Recommended for .NET 8.0        |

### Project upgrade details

This section contains details about each project upgrade and modifications that need to be done in the project.

#### aspnetmvcapp\aspnetmvcapp.csproj modifications

Project format changes:
  - Project file needs to be converted to SDK-style

Project properties changes:
  - Target framework should be changed from `net48` to `net8.0`

NuGet packages changes:
  - Antlr should be removed and replaced with Antlr4 version 4.6.6
  - Microsoft.AspNet.Mvc should be removed (functionality included with new framework reference)
  - Microsoft.AspNet.Razor should be removed (functionality included with new framework reference)
  - Microsoft.AspNet.Web.Optimization should be removed (no supported version found)
  - Microsoft.AspNet.WebPages should be removed (functionality included with new framework reference)
  - Microsoft.CodeDom.Providers.DotNetCompilerPlatform should be removed (functionality included with new framework reference)
  - Microsoft.jQuery.Unobtrusive.Validation should be updated from 3.2.11 to 4.0.0
  - Microsoft.Web.Infrastructure should be removed (functionality included with new framework reference)
  - Newtonsoft.Json should be updated from 13.0.3 to 13.0.4

Feature upgrades:
  - System.Web.Optimization bundling and minification is not supported in .NET Core and should be replaced with actual html tags pointing to content files
  - Convert application initialization code from Global.asax.cs to .NET Core and clean up Global.asax.cs

Other changes:
  - Web.config settings will need to be migrated to appsettings.json and program configuration
