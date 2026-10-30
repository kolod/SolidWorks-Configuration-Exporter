
# Include Modern UI
	!include "MUI2.nsh"

# General
	Unicode True
	Name "Configuration Exporter"                                    # Name of the installer (usually the name of the application to install).
	OutFile "SolidWorks-Configuration-Exporter-Installer.exe"        # name the installer
	InstallDir "$PROGRAMFILES64\SW Configuration Exporter"           # Default installing folder ($PROGRAMFILES is Program Files folder).
	InstallDirRegKey HKCU "Software\SW Configuration Exporter" ""    # Get installation folder from registry if available
	ShowInstDetails show                                             # This will always show the installation details.
	ShowUnInstDetails show                                           # This will always show the uninstallation details.
	RequestExecutionLevel admin                                      # Request application privileges for Windows Vista
	SetCompressor /SOLID lzma
	!define APP_MUTEX "SolidWorks-Configuration-Exporter"            # Created by the running application (see App.xaml.cs)

# Variables
	Var StartMenuFolder # Start menu folder

# Interface Settings
	!define MUI_ABORTWARNING          # This will warn the user if they exit from the installer.
	!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

# Pages
	# Start Menu Folder Page Configuration
	!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
	!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\Configuration Exporter" 
	!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Configuration Exporter"
	
	# Run application after install
	!define MUI_FINISHPAGE_RUN "$INSTDIR\Configuration Exporter.exe"
	
	!insertmacro MUI_PAGE_WELCOME                                   # Welcome to the installer page.
	!insertmacro MUI_PAGE_LICENSE "LICENSE"                         # License page
	!insertmacro MUI_PAGE_DIRECTORY                                 # In which folder install page.
	!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder    # Start menu page
	!insertmacro MUI_PAGE_INSTFILES                                 # Installing page.
	!insertmacro MUI_PAGE_FINISH                                    # Finished installation page.

	!insertmacro MUI_UNPAGE_CONFIRM
	!insertmacro MUI_UNPAGE_INSTFILES

# Languages
	!insertmacro MUI_LANGUAGE "English"
	!insertmacro MUI_LANGUAGE "Russian"

# Ask to close the application while its mutex exists
!macro CheckAppRunning
	check_running:
	System::Call 'kernel32::OpenMutex(i 0x00100000, i 0, t "${APP_MUTEX}") p .R0'
	IntPtrCmp $R0 0 not_running
	System::Call 'kernel32::CloseHandle(p R0)'
	MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "Configuration Exporter is running.$\r$\n$\r$\nClose it and click Retry to continue." IDRETRY check_running
	Abort
	not_running:
!macroend

Function un.onInit
	!insertmacro CheckAppRunning
FunctionEnd

# Check that the application is not running and the .NET 10 Desktop Runtime is installed
Function .onInit
	!insertmacro CheckAppRunning

	FindFirst $0 $1 "$PROGRAMFILES64\dotnet\shared\Microsoft.WindowsDesktop.App\10.*"
	FindClose $0
	StrCmp $1 "" 0 found
	MessageBox MB_YESNO|MB_ICONEXCLAMATION "Configuration Exporter requires the .NET 10 Desktop Runtime (x64), which is not installed.$\r$\n$\r$\nOpen the download page?" IDNO found
	ExecShell "open" "https://dotnet.microsoft.com/download/dotnet/10.0"
	found:
FunctionEnd

# Installer Sections
Section "Install"
	SetShellVarContext all   # Set all or current user for $SMPROGRAMS
	SetOutPath $INSTDIR      # define the output path for this file
	SetOverwrite ifnewer     # Owerwrite if newer
	SetAutoClose false       # Disable autoclose uninstallation page

	# define what to install and place it in the output path
	File LICENSE
	FILE "bin\Release\Configuration Exporter.exe"
	FILE "bin\Release\Configuration Exporter.dll"
	FILE "bin\Release\Configuration Exporter.deps.json"
	FILE "bin\Release\Configuration Exporter.runtimeconfig.json"
	
	# Store installation folder
	WriteUninstaller "$INSTDIR\Uninstall.exe"
	
	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
		
		# Save path to shortcuts
		WriteRegStr SHCTX "Software\SW Configuration Exporter" "" $INSTDIR
		WriteRegStr SHCTX "Software\SW Configuration Exporter" "StartMenuFolder" $StartMenuFolder
		
		# Create shortcuts
		CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
		CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Configuration Exporter.lnk" "$INSTDIR\Configuration Exporter.exe"
		CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
	!insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

# Uninstaller Section
Section "Uninstall"
	SetShellVarContext all   # Set all or current user for $SMPROGRAMS
	SetAutoClose false       # Disable autoclose uninstallation page
	
	Delete "$INSTDIR\*"
	Delete "$INSTDIR\Uninstall.exe"
	RMDir "$INSTDIR"
	
	ReadRegStr $StartMenuFolder SHCTX "Software\SW Configuration Exporter" "StartMenuFolder" 
	
	Delete "$SMPROGRAMS\$StartMenuFolder\Configuration Exporter.lnk"
	Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
	RMDir "$SMPROGRAMS\$StartMenuFolder"
	
	DeleteRegKey SHCTX "Software\SW Configuration Exporter\StartMenuFolder"
	DeleteRegKey SHCTX "Software\SW Configuration Exporter"
SectionEnd
