#!/bin/sh

# A `pinentry` replacement that uses a passphrase stored inside 1Password.
#
# Use as an alternative `pinentry-program` and set `OP_GPG_ITEM` to the URI.

COMMAND="op read $OP_GPG_ITEM"

echo "OK"
while read cmd rest; do
  echo "cmd=$cmd rest=$rest" >&2
  echo "cmd=$cmd rest=$rest" >> $LOG
  case "$cmd" in
    \#*)
      echo "OK"
      ;;
    GETPIN)
      PASSPHRASE=${PASSPHRASE-`$COMMAND`}
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