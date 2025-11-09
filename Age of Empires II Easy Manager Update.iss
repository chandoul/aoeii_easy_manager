#define APP_NAME "Age of Empires II Easy Manager"
#define APP_VERSION "3.9"
#define INSTALL_DIR "{commonpf}\Age of Empires II Easy Manager"
#define AHK "AutoHotkey"
#define SETUP_ICON "Bin\aoeii_em-icon.png"
#define SETUP_IMG "Bin\aoeii_em-side.png"
[Setup]
AppId=3BE8B710-F642-42F5-AEA1-75FB93B8A5A3
AppName={#APP_NAME} [ Update - {#APP_VERSION} ] 
AppVersion={#APP_VERSION}
AppVerName={#APP_NAME}
DefaultDirName={#INSTALL_DIR}
WizardSmallImageFile={#SETUP_ICON}
WizardImageFile={#SETUP_IMG}
OutputDir=Bin\update
OutputBaseFilename={#APP_NAME} [ Update - {#APP_VERSION} ] 
[Files]
Source: "AoE II Manager.json"; DestDir: "{app}";
Source: "DM.ahk"; DestDir: "{app}";
Source: "db\Base\cnc-ddraw.2\ddraw.ini"; DestDir: "{app}";
Source: "Bin\aoeii_em-icon.ico"; DestDir: "{app}";
Source: "lib\DownloadPackage.ahk"; DestDir: "{app}\lib";
[Icons]
Name: "{commondesktop}\AoE II Manager AIO"; Filename: "{app}\AoE II Manager AIO.ahk"; WorkingDir: "{app}"; IconFilename: "{app}\aoeii_em-icon.ico"