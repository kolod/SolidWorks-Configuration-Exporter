[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://vshymanskyy.github.io/StandWithUkraine/)

# SolidWorks-Configuration-Exporter [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
Tool for batch exporting all configurations of a SolidWorks project.

## Build requirements
* Windows with the .NET Framework 4.8 Developer Pack.
* SOLIDWORKS installed with the API interop assemblies in the default installation directory.
* Build with `dotnet build "Configuration Exporter.csproj"` or open the solution in Visual Studio.

## How to use
* Start SolidWorks.
* Open your model with multiple configurations.
* Start this program.
* Select file extension.
* Select output directory (if not selected will be used folder where original file saved).
* Push the Save button.

## Screenshot
![ScreenShot](https://github.com/kolod/SolidWorks-Configuration-Exporter/blob/main/screenshot.png?raw=true)
