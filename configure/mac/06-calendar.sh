#!/bin/bash

description() {
  echo "Configure Calendar"
}

main() {
  # Restart for changes to take effect.
  killall -q iCal
  
  exit 0
}

# Execute the main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi