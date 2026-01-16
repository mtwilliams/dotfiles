#!/bin/sh

# A `pinentry` replacement that uses a passphrase stored inside 1Password.
#
# Use as an alternative `pinentry-program` and set `OP_GPG_ITEM` to the URI.

echo "OK"
while read cmd rest; do
  echo "cmd=$cmd rest=$rest" >&2
  case "$cmd" in
    \#*)
      echo "OK"
      ;;
    GETPIN)
      if [ -z "$OP_GPG_ITEM" ]; then
        echo "ERR 83886179 OP_GPG_ITEM is not set"
        continue
      fi

      if [ -z "$PASSPHRASE" ]; then
        PASSPHRASE=$(op --account $OP_GPG_ACCOUNT read "$OP_GPG_ITEM" 2>/dev/null)
        if [ $? -ne 0 ] || [ -z "$PASSPHRASE" ]; then
          echo "ERR 83886179 Failed to retrieve passphrase from 1Password"
          continue
        fi
      fi

      echo "D ${PASSPHRASE}"
      echo "OK"
      ;;
    BYE)
      echo "OK"
      exit 0
      ;;
    *)
      echo "OK"
      ;;
  esac
done
