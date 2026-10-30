[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://vshymanskyy.github.io/StandWithUkraine/)

# SolidWorks-Configuration-Exporter [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
Tool for batch exporting all configurations of a SolidWorks project.

## Requirements
* [.NET 10 Desktop Runtime](https://dotnet.microsoft.com/download/dotnet/10.0) to run the program (the installer offers to download it if missing).

## Build requirements
* Windows with the .NET 10 SDK.
* SOLIDWORKS is not required for building: the API interop assemblies come from the `Visiativ.SOLIDWORKS.Interop` NuGet package and their types are embedded into the executable.
* Build with `dotnet build "Configuration Exporter.csproj"` or open the solution in Visual Studio.
* To build the installer and the portable ZIP into `artifacts/installer` (requires [NSIS](https://nsis.sourceforge.io)), run `pwsh Build-Installer.ps1`. Add `-Install` to install the new build over the installed copy right away.

## How to use
* Start SolidWorks.
* Open your model with multiple configurations.
* Start this program.
* Select file extension.
* Select output directory (if not selected will be used folder where original file saved).
* Push the Save button.

## Screenshot
![ScreenShot](https://github.com/kolod/SolidWorks-Configuration-Exporter/blob/main/screenshot.png?raw=true)
