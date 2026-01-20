export LANG='en_US.UTF-8'
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LESS='-F -g -i -M -Q -R -S -w -X -x2 -z-4 -~'
export LESS_TERMCAP_mb=$'\E[5m'
export LESS_TERMCAP_md=$'\E[1;97m'
export LESS_TERMCAP_us=$'\E[2;4m'
export LESS_TERMCAP_so=$'\E[7m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export PYTHONSTARTUP="$HOME/.pythonrc"

# Passphrase for GPG is stored inside a 1Password vault, and an alternative
# `pinentry-program` program is used to fetch it from 1Password CLI.
#
# See `extra/pinentry.sh`.
export OP_GPG_ACCOUNT="my.1password.com"
export OP_GPG_ITEM="op://pys6op3sognebycneijjr6mbku/fctlmayanvvnxubdlm3nzcaafe/Passphrase"

# Toolchain.
[ -r ~/.local/bin/env ] && . ~/.local/bin/env
if [ -n "${ZSH_VERSION:-}" ]; then
  [ -r ~/.local/bin/mise ] && eval "$(~/.local/bin/mise activate zsh)"
elif [ -n "${BASH_VERSION:-}" ]; then
  [ -r ~/.local/bin/mise ] && eval "$(~/.local/bin/mise activate bash)"
fi
[ -r ~/.cargo/env ] && . ~/.cargo/env

# Homebrew.
if [ "$(uname -s)" = "Darwin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Custom scripts.
export PATH="$PATH:$HOME/.dotfiles/bin"
