#Requires AutoHotkey v2
#SingleInstance Force

#Include <WatchOut>
#Include <ReadWriteJSON>

Setting := ReadSetting()
GRApp := Setting['GRApp']
HAI := Setting['HAI']
Possibilities := HAI['Possibilities']
VPNPath := (A_Is64bitOS ? EnvGet('ProgramFiles(x86)') : EnvGet('ProgramFiles')) HAI['VPNPath']
SetRegView(A_Is64bitOS ? 64 : 32)
LayersHKLM := Setting['LayersHKLM']
LayersHKCU := Setting['LayersHKCU']

AoEIIAIO := Gui(, 'HIDE ALL IP TRIAL RESET')
AoEIIAIO.BackColor := 'White'
AoEIIAIO.OnEvent('Close', (*) => ExitApp())
AoEIIAIO.MarginX := AoEIIAIO.MarginY := 10
AoEIIAIO.SetFont('s10 Bold', 'Calibri')

AoEIIAIO.SetFont('s16')
H := AoEIIAIO.AddButton(, 'Hide All IP Trial Reset [ Attempt ' (Index := 1) ' / ' Possibilities.Length ' ]')
H.SetFont('s10 Bold', 'Calibri')
H.OnEvent('Click', ResetProcess)
ResetProcess(Ctrl, Info) {
    Try {
        Global Index
        CompatClear(GRApp)
        CompatClear(VPNPath)
        Log := ''
        Switch Possibilities[Index] {
            Case 'CLEAR':
                Loop Parse, "HKCU|HKLM", '|' {
                    HK := A_LoopField
                    Loop Parse, "Software\HideAllIP|Software\Wow6432Node\HideAllIP", '|' {
                        Loop Reg, HK "\" A_LoopField {
                            RegDeleteKey(A_LoopRegkey)
                        }
                    }
                }
                Log := 'Cleared registery'
            Default:
                CompatSet(VPNPath, Possibilities[Index])
                Log := 'Set compatibility = ' Possibilities[Index] ''
        }
        ; Update attempts
        If ++Index > Possibilities.Length {
            Index := 1
        }
        H.Text := 'Hide All IP Trial Reset [ Attempt ' Index ' / ' Possibilities.Length ' ]'
        Logs.Value := Log
        MsgBox('Attempt ' Index ' / ' Possibilities.Length '`n`n' Log, 'OK', 0x40)
        If ProcessExist('HideALLIP.exe') {
            ProcessClose('HideALLIP.exe')
        }
        If 'Yes' != Msgbox('Launch Hide All IP?', 'Hide All IP', 0x40 + 0x4 ' T5') {
            Return
        }
        If !FileExist(VPNPath) {
            Msgbox('You must install Hide All IP!', 'Unable to run', 0x30)
            Return
        }
        Run(VPNPath)
    } Catch Error As Err {
        MsgBox("Reset failed!`n`n" Err.Message '`n' Err.Line '`n' Err.File, 'Version', 0x10)
    }
}
AoEIIAIO.SetFont('s12')
Logs := AoEIIAIO.AddEdit('wp Center cBlue -E0x200')
AoEIIAIO.Show()

Msgbox('This tool is outdated, so probably it wont work anymore!', 'HIDE ALL IP TRIAL RESET', 0x40)

CompatClear(ValueName) {
    If RegRead(LayersHKCU, ValueName, '')
        RegDelete(LayersHKCU, ValueName)
    If RegRead(LayersHKLM, ValueName, '')
        RegDelete(LayersHKLM, ValueName)
}

CompatSet(ValueName, Value) {
    RegWrite(Value, 'REG_SZ', LayersHKCU, ValueName)
    RegWrite(Value, 'REG_SZ', LayersHKLM, ValueName)
}