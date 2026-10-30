#Requires -Version 7.2
<#
.SYNOPSIS
    Builds, verifies and packages Configuration Exporter: NSIS installer and portable ZIP.

.DESCRIPTION
    Release build (warnings as errors) and tests, verification of the build output, NSIS compilation
    and the portable ZIP. Stops at the first failure; a failed run leaves no installer and no ZIP in
    the output folder.

    -Install then installs the new build right away over the installed copy: a running app is closed
    first, setup runs silently (after the UAC prompt) and the installed app is started again.

.EXAMPLE
    pwsh Build-Installer.ps1
    pwsh Build-Installer.ps1 -SkipTests -Install
#>
[CmdletBinding()]
param(
    [switch] $SkipTests,
    [switch] $Install,
    [string] $NsisPath,
    [string] $OutputDir = 'artifacts/installer'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = $PSScriptRoot
$Project = Join-Path $Root 'Configuration Exporter.csproj'
$Script = Join-Path $Root 'install.nsi'
$BuildDir = Join-Path $Root 'bin/Release'
$OutputDir = [IO.Path]::GetFullPath((Join-Path $Root $OutputDir))
$AppName = 'Configuration Exporter'
$Summary = [ordered]@{}

# Files the installer and the ZIP ship (install.nsi lists the same ones)
$AppFiles = @(
    "$AppName.exe",
    "$AppName.dll",
    "$AppName.deps.json",
    "$AppName.runtimeconfig.json"
)

function Invoke-Step([string] $Name, [scriptblock] $Action) {
    Write-Host "==> $Name" -ForegroundColor Cyan
    try {
        & $Action
    }
    catch {
        throw "Step '$Name' failed: $($_.Exception.Message)"
    }
}

function Invoke-Native([string] $File, [string[]] $Arguments) {
    & $File @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$([IO.Path]::GetFileName($File)) exited with code $LASTEXITCODE"
    }
}

function Format-Size([long] $Bytes) {
    [string]::Format([cultureinfo]::InvariantCulture, '{0:N1} KB', $Bytes / 1KB)
}

function Find-Makensis {
    $candidates = @(
        $NsisPath,
        (Get-Command makensis -ErrorAction SilentlyContinue)?.Source,
        (Join-Path ${env:ProgramFiles(x86)} 'NSIS/makensis.exe'),
        (Join-Path $env:ProgramFiles 'NSIS/makensis.exe')
    ) | Where-Object { $_ -and (Test-Path $_) }

    $makensis = $candidates | Select-Object -First 1
    if (-not $makensis) {
        throw 'NSIS not found. Install it (winget install NSIS.NSIS) or pass -NsisPath.'
    }
    return $makensis
}

function Get-InstalledExe {
    # install.nsi stores the folder in HKLM; the 32-bit installer writes to the WOW6432Node view.
    foreach ($key in 'HKLM:\SOFTWARE\WOW6432Node\SW Configuration Exporter', 'HKLM:\SOFTWARE\SW Configuration Exporter') {
        $location = (Get-ItemProperty $key -ErrorAction SilentlyContinue)?.'(default)'
        if ($location -and (Test-Path (Join-Path $location "$AppName.exe"))) { return Join-Path $location "$AppName.exe" }
    }
    return $null
}

function Install-Build([string] $Installer) {
    # Setup refuses to run while the app holds its mutex; close the running app first.
    foreach ($process in Get-Process $AppName -ErrorAction SilentlyContinue) {
        Write-Host "Closing $AppName (PID $($process.Id))"
        [void] $process.CloseMainWindow()
        if (-not $process.WaitForExit(15000)) { throw "$AppName (PID $($process.Id)) did not close within 15 s; close it and run again" }
    }
    # The installer requests admin rights; Start-Process shows the UAC prompt.
    $process = Start-Process $Installer -Wait -PassThru -ArgumentList '/S'
    if ($process.ExitCode -ne 0) { throw "Setup exited with code $($process.ExitCode)" }
    $exe = Get-InstalledExe
    if (-not $exe) { throw "Setup finished, but the installed $AppName.exe was not found" }
    Start-Process $exe
    return $exe
}

try {
    Invoke-Step 'Prepare output folder' {
        if (Test-Path $OutputDir) { Remove-Item $OutputDir -Recurse -Force }
        New-Item -ItemType Directory -Force $OutputDir | Out-Null
    }

    $version = $null
    $makensis = $null
    Invoke-Step 'Read version and check tools' {
        $assemblyInfo = Get-Content (Join-Path $Root 'Properties/AssemblyInfo.cs') -Raw
        if ($assemblyInfo -notmatch '(?m)^\[assembly: AssemblyVersion\("(\d+\.\d+\.\d+)\.\d+"\)\]') { throw 'AssemblyVersion not found in Properties/AssemblyInfo.cs' }
        $script:version = $Matches[1]
        $script:makensis = Find-Makensis
        $Summary.Version = $script:version
        $Summary.NSIS = (& $script:makensis /VERSION | Out-String).Trim()
    }

    Invoke-Step 'Release build (warnings as errors)' {
        Invoke-Native dotnet @('build', $Project, '-c', 'Release', '-warnaserror', '-nologo', '-v', 'q')
    }

    if ($SkipTests) {
        Write-Warning 'Tests skipped (-SkipTests). Do not distribute this build.'
        $Summary.Tests = 'skipped'
    }
    else {
        Invoke-Step 'Tests' {
            $tests = Get-ChildItem $Root -Recurse -Filter '*Tests.csproj' | Where-Object FullName -NotMatch '[\\/](bin|obj)[\\/]'
            if (-not $tests) {
                Write-Warning 'No test projects found.'
                $Summary.Tests = 'none'
                return
            }
            foreach ($test in $tests) { Invoke-Native dotnet @('test', $test.FullName, '-c', 'Release', '-nologo') }
            $Summary.Tests = 'passed'
        }
    }

    Invoke-Step 'Verify build output' {
        foreach ($name in $AppFiles) {
            if (-not (Test-Path (Join-Path $BuildDir $name))) { throw "$name is missing in $BuildDir" }
        }
        # Interop types are embedded into the app (EmbedSolidWorksInteropTypes in the .csproj)
        $interop = Get-ChildItem $BuildDir -Filter 'SolidWorks.Interop.*.dll'
        if ($interop) { throw "SOLIDWORKS interop assemblies must not be shipped: $($interop.Name -join ', ')" }
    }

    $installer = Join-Path $OutputDir "SolidWorks-Configuration-Exporter-Installer-$version.exe"
    Invoke-Step 'Compile installer' {
        Invoke-Native $makensis @('/V2', "/DOUTFILE=$installer", $Script)
        $Summary.Installer = "$([IO.Path]::GetFileName($installer)) ($(Format-Size (Get-Item $installer).Length))"
    }

    Invoke-Step 'Portable ZIP' {
        $zip = Join-Path $OutputDir "SolidWorks-Configuration-Exporter-$version.zip"
        $files = @($AppFiles | ForEach-Object { Join-Path $BuildDir $_ }) + (Join-Path $Root 'LICENSE')
        Compress-Archive -Path $files -DestinationPath $zip -CompressionLevel Optimal
        $Summary.Portable = "$([IO.Path]::GetFileName($zip)) ($(Format-Size (Get-Item $zip).Length))"
    }

    $Summary.Result = 'passed'
    Write-Host "Build succeeded: version $version" -ForegroundColor Green
}
catch {
    # A failed run must not leave an installer or a ZIP behind.
    Get-ChildItem $OutputDir -Include '*.exe', '*.zip' -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force
    Write-Host $_.Exception.Message -ForegroundColor Red
    $Summary.Result = "FAILED: $($_.Exception.Message)"
}
finally {
    if (Test-Path $OutputDir) {
        $Summary.GetEnumerator() | ForEach-Object { '{0}: {1}' -f $_.Key, $_.Value } |
            Set-Content (Join-Path $OutputDir 'summary.txt') -Encoding utf8
    }
}

# Outside the build's try: a failed install (UAC declined, app not closing) keeps the verified installer.
$installFailed = $false
if ($Install -and $Summary.Result -eq 'passed') {
    try {
        Invoke-Step 'Install' {
            $exe = Install-Build $installer
            Write-Host "Installed and started: $exe" -ForegroundColor Green
        }
    }
    catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
        $installFailed = $true
    }
}

exit ($Summary.Result -eq 'passed' -and -not $installFailed ? 0 : 1)
