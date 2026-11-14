Dim WshShell, fso, appData, localAppData, antigravityExe, serviceJs, argStr, i, nodeExe
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

appData = WshShell.ExpandEnvironmentStrings("%APPDATA%")
localAppData = WshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%")

antigravityExe = localAppData & "\Programs\antigravity\Antigravity.exe"
serviceJs = appData & "\antigravity-rtl\service.js"

' 1. Rebuild commandline arguments passed to launcher
argStr = ""
For i = 0 To WScript.Arguments.Count - 1
    argStr = argStr & " """ & WScript.Arguments(i) & """"
Next

' 2. Launch Antigravity
WshShell.Run """" & antigravityExe & """" & argStr, 1, False

' 3. Launch the RTL background watcher service with it
If fso.FileExists(serviceJs) Then
    nodeExe = "node.exe"
    If fso.FileExists("C:\Program Files\nodejs\node.exe") Then
        nodeExe = "C:\Program Files\nodejs\node.exe"
    ElseIf fso.FileExists("C:\Program Files (x86)\nodejs\node.exe") Then
        nodeExe = "C:\Program Files (x86)\nodejs\node.exe"
    End If
    WshShell.Run """" & nodeExe & """ """ & serviceJs & """", 0, False
End If
