#!/bin/bash

description() {
  echo "Install Rust"
}

main() {
  # Install Rust through `rustup`.
  #
  # https://rust-lang.github.io/rustup/index.html
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile default

  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
