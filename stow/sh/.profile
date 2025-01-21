if [[ "$OSTYPE" == "darwin"* ]]; then

  # Don't have `pinentry` on Mac.
  export GPG_TTY=$(tty)
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

[[ -r ~/.asdf/asdf.sh ]] && . ~/.asdf/asdf.sh
[[ -r ~/.cargo/env ]] && . ~/.cargo/env