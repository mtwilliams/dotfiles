if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Passphrase for GPG is stored inside a 1Password vault, and an alternative
# `pinentry-program` program is used to fetch it from 1Password CLI.
#
# See `extra/pinentry.sh`.
export OP_GPG_ITEM="op://pys6op3sognebycneijjr6mbku/fctlmayanvvnxubdlm3nzcaafe/Passphrase"

[[ -r ~/.asdf/asdf.sh ]] && . ~/.asdf/asdf.sh
[[ -r ~/.cargo/env ]] && . ~/.cargo/env
