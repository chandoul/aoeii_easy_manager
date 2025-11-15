#define APP_NAME    "Age of Empires II Easy Manager"
#define APP_VERSION "3.9"
#define INSTALL_DIR "{commonpf}\Age of Empires II Easy Manager"
#define AHK         "AutoHotkey"
#define SETUP_ICON  "Bin\aoeii_em-icon.png"
#define SETUP_IMG   "Bin\aoeii_em-side.png"
#define APP_38      "https://github.com/Chandoul/aoeii_easy_manager/raw/refs/heads/main/Bin/AoE%20II%20Manager%20AIO.exe"

[Setup]
AppId               = 3BE8B710-F642-42F5-AEA1-75FB93B8A5A3
AppName             = {#APP_NAME} [ Update - {#APP_VERSION} ] 
AppVersion          = {#APP_VERSION}
AppVerName          = {#APP_NAME}
DefaultDirName      = {#INSTALL_DIR}
WizardSmallImageFile= {#SETUP_ICON}
WizardImageFile     = {#SETUP_IMG}
OutputDir           = Bin\update
OutputBaseFilename  = {#APP_NAME} [ Update - {#APP_VERSION} ] 

[Files]
Source: "AoE II Manager.json"; DestDir: "{app}";
Source: "DM.ahk"; DestDir: "{app}";
Source: "db\Base\cnc-ddraw.2\ddraw.ini"; DestDir: "{app}\db\Base\cnc-ddraw.2";
Source: "Bin\aoeii_em-icon.ico"; DestDir: "{app}";
Source: "lib\DownloadPackage.ahk"; DestDir: "{app}\lib";

[Icons]
Name: "{commondesktop}\{#APP_NAME}"; Filename: "{app}\AoE II Manager AIO.ahk"; WorkingDir: "{app}"; IconFilename: "{app}\aoeii_em-icon.ico"

[Code]
var DownloadPage: TDownloadWizardPage;
	CancelDownload: Boolean;

function OnDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
begin
    //if Progress = ProgressMax then
    //    Log(Format('Successfully downloaded file to {tmp}: %s', [FileName]));
    //Result := True;
	if CancelDownload then
  	begin
  	  	Result := False;
  	  	MsgBox('Download was stopped by user request.', mbInformation, MB_OK);
  	end;
end;

procedure InitializeWizard;
begin
    DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), @OnDownloadProgress);
end;

function EasyManagerExists(): Boolean; 
begin;
    Result := FileExists(ExpandConstant('{commonpf}\Age of Empires II Easy Manager\AoE II Manager.json'))
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var ResultCode: Integer;
begin
  	if CurPageID = wpReady then 
	begin
		try
    		DownloadPage.Clear;
    		if EasyManagerExists() then
			begin
				DownloadPage.Add('{#APP_38}', 'aoeii-em-latest.exe', '');
    			DownloadPage.Show;
				DownloadPage.Download; 
				ShellExec('', ExpandConstant('{tmp}\aoeii-em-latest.exe'), '', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode)
			end;
			if not EasyManagerExists() then 
    		begin
    		    MsgBox('{#APP_NAME} v3.8 is not installed! [ Required ], setup now will exit.', mbError, MB_OK);  
    		    Result := False;
    		end;
    	except 
			SuppressibleMsgBox(AddPeriod(GetExceptionMessage), mbCriticalError, MB_OK, IDOK); 
			Result := False;
		end;
  	end;
    Result := True;
end;