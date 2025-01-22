#!/bin/bash

description() {
  echo "Setup keyboard shortcuts"
}

main() {
  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
