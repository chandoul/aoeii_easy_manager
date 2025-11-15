#Requires AutoHotkey v2
#SingleInstance Force

#Include <WatchOut>

If !A_IsAdmin {
    MsgBox('Script must run as administrator!', 'Warn', 0x30)
    ExitApp()
}

#Include <ImageButton>
#Include <IBButtons>
#Include <ValidGame>
#Include <ReadWriteJSON>
#Include <DownloadPackage>
#Include <ExtractPackage>
#Include <WatchFileSize>
#Include <HashFile>

Features := Map()
Features['Main'] := []
AppName := ReadSetting(, 'AppName')
Version := ReadSetting(, 'Version')
Latest := ReadSetting(, 'Latest')

AoEIIAIO := Gui(, 'Age of Empires II Easy Manager!')
AoEIIAIO.BackColor := 'White'
AoEIIAIO.OnEvent('Close', (*) => ExitApp())
AoEIIAIO.MarginX := AoEIIAIO.MarginY := 10
AoEIIAIO.SetFont('s10', 'Segoe UI')

CreateImageButton("SetDefGuiColor", '0x030303')

WD := AoEIIAIO.AddButton('x0 y0', '...')
AoEIIAIO.SetFont('Bold s18')
T := AoEIIAIO.AddText('xm cGreen Center BackgroundTrans y40', AppName ' v' Version)
P := AoEIIAIO.AddPicture('xm+90 y80', 'DB\Base\game.png')

AoEIIAIO.SetFont('Bold s8 ')
A := AoEIIAIO.AddText('xm cGray Center BackgroundTrans y260', 'A homemade tool humbly made by Smile, enjoy!')
AoEIIAIO.SetFont('Bold s12 Bold')

R := AoEIIAIO.AddButton('xm ym+30 w100', 'Reload')
R.SetFont('Bold s10')
CreateImageButton(R, 0, IBRed*)
R.OnEvent('Click', (*) => Reload())

U := AoEIIAIO.AddButton('w100', 'Update')
U.SetFont('Bold s10')
CreateImageButton(U, 0, IBBlue*)
U.OnEvent('Click', (*) => Run('https://chandoul.github.io'))

LnchMap := Map()
LnchPID := Map()

AoEIIAIO.SetFont('Bold s10')
H := AoEIIAIO.AddButton('xm y310 w150', 'My Game')
LnchMap['My Game'] := 'Game.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)

LaunchSubApp(Ctrl, Info) {
    Try {
        Run(LnchMap[Ctrl.Text], , , &PID)
        LnchPID[LnchMap[Ctrl.Text]] := PID
    }
    Catch Error As Err
        MsgBox("Launch failed!`n`n" Err.Message '`n' Err.Line '`n' Err.File, 'Game', 0x10)
}

H := AoEIIAIO.AddButton('yp wp', 'Version')
LnchMap['Version'] := 'Version.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)
Features['Main'].Push(H)

H := AoEIIAIO.AddButton('yp wp', 'Patch/Fix')
LnchMap['Patch/Fix'] := 'Fixs.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)
Features['Main'].Push(H)

H := AoEIIAIO.AddButton('yp wp', 'Language')
LnchMap['Language'] := 'Language.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)
Features['Main'].Push(H)

H := AoEIIAIO.AddButton('yp wp', 'Visual Mods')
LnchMap['Visual Mods'] := 'VM.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)
Features['Main'].Push(H)

H := AoEIIAIO.AddButton('yp wp', 'Data Mods')
LnchMap['Data Mods'] := 'DM.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)
Features['Main'].Push(H)

H := AoEIIAIO.AddButton('xm y350 wp', 'Hide All IP')
LnchMap['Hide All IP'] := 'VPN.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)
Features['Main'].Push(H)

H := AoEIIAIO.AddButton('yp wp', 'Shortcuts')
LnchMap['Shortcuts'] := 'AHK.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)
Features['Main'].Push(H)

H := AoEIIAIO.AddButton('yp wp', 'Direct Draw Fix')
LnchMap['Direct Draw Fix'] := 'DDF.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)
Features['Main'].Push(H)

H := AoEIIAIO.AddButton('yp wp+160', 'GameRanger Account Switcher')
LnchMap['GameRanger Account Switcher'] := 'GRAS.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)
Features['Main'].Push(H)

H := AoEIIAIO.AddButton('yp w150', 'Scenarios')
LnchMap['Scenarios'] := 'Scx.ahk'
CreateImageButton(H, 0, IBBlack*)
H.OnEvent('Click', LaunchSubApp)
Features['Main'].Push(H)

OnExit(SubAppsClose)
SubAppsClose(ExitReason, ExitCode) {
    For SubApp, PID in LnchPID {
        Try ProcessClose(PID)
    }
}

AoEIIAIO.Show()
R.Redraw()
AoEIIAIO.GetPos(, , &W, &H)
R.GetPos(, &Y)
U.GetPos(, , &WU)
U.Move(W - WU - 25, Y)
U.Redraw()
T.Move(0, , W)
T.Redraw()
A.Move(0, , W)
A.Redraw()
P.Move((W - 605) / 2)
P.Redraw()
WD.Move(, , W - 16)
WD.SetFont('Bold s10', 'Segoe UI')
CreateImageButton(WD, 0, IBGray*)
WD.OnEvent('Click', (*) => OpenGameFolder())
OpenGameFolder() {
    GameDirectory := ReadSetting('Setting.json', 'GameLocation', '')
    If ValidGameDirectory(GameDirectory) {
        Run(GameDirectory '\')
    } Else MsgBox('You must select your game folder!', 'Info', 0x30)
}
GameDirectory := ReadSetting('Setting.json', 'GameLocation', '')
If !ValidGameDirectory(GameDirectory) {
    P.Value := 'DB\Base\gameoff.png'
    For Each, Version in Features['Main'] {
        Switch Version.Text {
            Case "Hide All IP"
                , "GameRanger Account Switcher"
                , "Shortcuts": Continue
            Default: Version.Enabled := False
        }
    }
    If 'Yes' = MsgBox('Game is not yet located!, want to select now?', 'Game', 0x4 + 0x40) {
        Run('Game.ahk')
    }
    Return
}
WD.Text := 'Current selection: "' GameDirectory '"'
CreateImageButton(WD, 0, IBGray*)

; Gameux Win7/Vista auto fix
GEs := [
    A_WinDir '\System32\gameux.dll',
    A_WinDir '\SysWOW64\gameux.dll'
]
For GE in GEs {
    Switch SubStr(A_OSVersion, 1, 3) {
        Case '6.0', '6.1':
            If FileExist(GE) && 'Yes' = MsgBox('If your games are being delayed when you start them apply this hotfix otherwise skip it!`n`nTarget File: ' GE, 'Gameux', 0x40 + 0x4) {
                RunWait(A_ComSpec ' /c takeown /f ' A_WinDir '\System32\gameux.dll && cacls ' A_WinDir '\System32\gameux.dll /E /P %username%:F && ren ' A_WinDir '\System32\gameux.dll gameux_renamed.dll', , 'Hide')
            }
    }
}