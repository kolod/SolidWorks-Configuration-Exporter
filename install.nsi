
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

# Installer Sections
Section "Install"
	SetShellVarContext all   # Set all or current user for $SMPROGRAMS
	SetOutPath $INSTDIR      # define the output path for this file
	SetOverwrite ifnewer     # Owerwrite if newer
	SetAutoClose false       # Disable autoclose uninstallation page

	# define what to install and place it in the output path
	File LICENSE
	FILE "bin\Release\Configuration Exporter.exe"
	FILE "bin\Release\Configuration Exporter.exe.config"
	FILE "bin\Release\*.dll"
	FILE "bin\Release\*.xml"
	
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
