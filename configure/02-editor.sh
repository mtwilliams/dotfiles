#!/bin/bash

description() {
  echo "Configure Cursor"
}

main() {
  local SETTINGS

  ## Config

  if [[ "$PLATFORM" == "mac" ]]; then
    SETTINGS="$HOME/Library/Application Support/Cursor/User/settings.json"
  else
    SETTINGS="$HOME/.config/Cursor/User/settings.json"

    # Ensure the directory exists.
    mkdir -p $(dirname "$SETTINGS")
  fi

  rm "$SETTINGS" 2>/dev/null
  ln -s "$HOME/.dotfiles/cursor.json" "$SETTINGS"

  ## Extensions

  # Install theme for Cursor.
  cursor --install-extension teabyii.ayu

  # Install GitLens.
  cursor --install-extension eamodio.gitlens

  # Install Github related extensions.
  # cursor --install-extension GitHub.copilot-chat
  # cursor --install-extension GitHub.vscode-github-actions
  # cursor --install-extension GitHub.vscode-pull-request-github

  # C/C++
  cursor --install-extension ms-vscode.cpptools

  # Rust
  cursor --install-extension rust-lang.rust-analyzer

  # Python
  cursor --install-extension ms-python.python
  cursor --install-extension ms-python.debugpy

  # Erlang/Elixir
  cursor --install-extension pgourlain.erlang
  cursor --install-extension JakeBecker.elixir-ls

  # Docker
  cursor --install-extension ms-azuretools.vscode-docker

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
