#!/bin/bash

description() {
  echo "Configure Visual Studio Code"
}

main() {
  local SETTINGS

  ## Config

  if [[ "$PLATFORM" == "mac" ]]; then
    SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
  else
    SETTINGS="$HOME/.config/Code/User/settings.json"

    # Ensure the directory exists.
    mkdir -p $(dirname "$SETTINGS")
  fi

  rm "$SETTINGS" 2>/dev/null
  ln -s "$HOME/.dotfiles/vscode.json" "$SETTINGS"

  ## Extensions

  # Install theme for VSCode.
  code --install-extension dracula-theme.theme-dracula

  # Install GitLens.
  code --install-extension eamodio.gitlens

  # Install Github related extensions.
  # code --install-extension GitHub.copilot-chat
  # code --install-extension GitHub.vscode-github-actions
  # code --install-extension GitHub.vscode-pull-request-github

  # C/C++
  code --install-extension ms-vscode.cpptools

  # Rust
  code --install-extension rust-lang.rust-analyzer

  # Python
  code --install-extension ms-python.python
  code --install-extension ms-python.debugpy

  # Erlang/Elixir
  code --install-extension pgourlain.erlang
  code --install-extension JakeBecker.elixir-ls

  # Docker
  code --install-extension ms-azuretools.vscode-docker

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
