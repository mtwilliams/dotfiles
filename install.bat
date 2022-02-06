@echo off

echo Run the following in an elevated command prompt:
echo:

echo del "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json"
echo mklink "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json" "%1\vscode.json"

echo del "C:\Users\%USERNAME%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
echo mklink "C:\Users\%USERNAME%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "%1\terminal.json"

echo:
