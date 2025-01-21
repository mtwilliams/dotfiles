#!/bin/bash

description() {
  echo "Install asdf and plugins"
}

main() {
  # Install the recommended way, through Git.
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.15.0

  # Make `asdf` available under `bash` and `zsh` until we perform additional setup.
  echo >> ~/.bash_profile
  echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bash_profile
  echo >> ~/.zprofile
  echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zprofile

  # Make `asdf` availabe for the remainder of this script.
  . "$HOME/.asdf/asdf.sh"

  # Install plugins for languages of choice.
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf plugin add python https://github.com/danhper/asdf-python.git
  asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
  asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
