Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
appData = WshShell.ExpandEnvironmentStrings("%APPDATA%")
servicePath = appData & "\antigravity-rtl\service.js"

nodeExe = "node.exe"
If fso.FileExists("C:\Program Files\nodejs\node.exe") Then
    nodeExe = "C:\Program Files\nodejs\node.exe"
ElseIf fso.FileExists("C:\Program Files (x86)\nodejs\node.exe") Then
    nodeExe = "C:\Program Files (x86)\nodejs\node.exe"
End If

WshShell.Run """" & nodeExe & """ """ & servicePath & """", 0, False
