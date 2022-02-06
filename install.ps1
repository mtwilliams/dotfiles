$dotfiles = $pwd.Path.split('::')[2]
$script = $dotfiles + "\\install.bat"

Set-Location -Path "C:\"

cmd.exe /c "${script} ${dotfiles}"
