Dim WshShell, fso, appData, localAppData, ideExe, serviceJs, argStr, i, nodeExe
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

appData = WshShell.ExpandEnvironmentStrings("%APPDATA%")
localAppData = WshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%")

ideExe = localAppData & "\Programs\Antigravity IDE\Antigravity IDE.exe"
serviceJs = appData & "\antigravity-rtl\service.js"

' 1. Rebuild commandline arguments passed to launcher
argStr = ""
For i = 0 To WScript.Arguments.Count - 1
    argStr = argStr & " """ & WScript.Arguments(i) & """"
Next

' 2. Locate Node runtime
nodeExe = "node.exe"
If fso.FileExists("C:\Program Files\nodejs\node.exe") Then
    nodeExe = "C:\Program Files\nodejs\node.exe"
ElseIf fso.FileExists("C:\Program Files (x86)\nodejs\node.exe") Then
    nodeExe = "C:\Program Files (x86)\nodejs\node.exe"
End If

' 3. Fast pre-launch auto-healing (synchronous ~35ms) to guarantee injection before IDE window opens
If fso.FileExists(serviceJs) Then
    WshShell.Run """" & nodeExe & """ """ & serviceJs & """ --inject-only", 0, True
End If

' 4. Launch Antigravity IDE
WshShell.Run """" & ideExe & """" & argStr, 1, False

' 5. Ensure background watcher daemon is active
If fso.FileExists(serviceJs) Then
    WshShell.Run """" & nodeExe & """ """ & serviceJs & """", 0, False
End If
