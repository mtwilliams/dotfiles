#!/usr/bin/env bash

if [[ "$HOME/.dotfiles" != $(dirname "$(readlink -f "$0")") ]]; then
  echo "Clone to ~/.dotfiles and nowhere else!" >&2
  exit 1
fi

if [[ "$(< /proc/version)" == *@(Microsoft|WSL)* ]]; then
  export WINDOWS=1
else
  export MAC=0
fi

## Visual Studio Code

rm -f $HOME/.vscode/settings.json
mkdir -p $HOME/.vscode
ln -s $HOME/.dotfiles/vscode.json $HOME/.vscode/settings.json

# Install theme for VSCode.
code --install-extension dracula-theme.theme-dracula

# Install GitLens.
code --install-extension eamodio.gitlens

# Install language extensions.
code --install-extension ms-vscode.cpptools
code --install-extension jakebecker.elixir-ls

echo "\n"

## Git

rm -f $HOME/.gitconfig $HOME/.gitignore
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
ln -s $HOME/.dotfiles/.gitignore $HOME/.gitignore

if [[ "$WINDOWS" == 1 ]]; then
  # Use VSCode on Windows.
  echo "Using 'vscode' for difftool and mergetool."
  git config --global diff.tool vscode
  git config --global merge.tool vscode
fi

if [[ "$MAC" == 1 ]]; then
  # Use Kaleidoscope on Mac.
  echo "Using 'kaleidoscope' for difftool and mergetool."
  git config --global diff.tool kaleidoscope
  git config --global merge.tool kaleidoscope
fi

## Windows requires additional commands.

if [[ "$WINDOWS" == 1 ]]; then
  powershell.exe -File "install.ps1"
fi

echo "Done."
