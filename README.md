# dotfiles

Personal configuration for macOS and other Unixes.

## Quick Start

### Fresh

Run the bootstrap script to set up a new machine from scratch:

```sh
curl -fsSL https://raw.githubusercontent.com/mtwilliams/dotfiles/main/bootstrap.sh | bash
```

This will:
1. Prompt for Full Disk Access permissions
2. Install Homebrew
3. Install Xcode via the App Store
4. Install essential tools (`coreutils`, `git`, `gnupg`, etc.)
5. Clone this repository to `~/.dotfiles`
6. Run the configuration scripts

### Existing Setup

If you already have the repo cloned, re-run configuration with:

```sh
~/.dotfiles/configure.sh
```

## Structure

```
~/.dotfiles/
├── bin/              # Scripts added to PATH
│   └── dotfiles      # GNU Stow wrapper for managing dotfiles
├── blackhole/        # Local DNS-based ad blocking
├── configure/        # Configuration scripts
│   ├── once/         # Run once (idempotent)
│   ├── mac/          # macOS-specific (always run)
│   └── *.sh          # Cross-platform (always run)
├── extra/            # Optional/supplementary scripts
├── flags/            # Tracks which "once" scripts have run
├── stow/             # Dotfile packages managed by GNU Stow
└── wallpapers/       # Desktop backgrounds
```

## Shell

I use an explicit chain so `bash` and `zsh` share the same tool
setup without duplication:
- `~/.zshenv` → `~/.profile` (zsh, all shells)
- `~/.bashrc` → `~/.profile` (bash, interactive shells)
- `~/.bash_profile` → `~/.bashrc` (bash, login shells)

## Configuration Scripts

Scripts follow a consistent pattern:

```sh
#!/bin/bash

description() {
  echo "Human-readable description"
}

main() {
  # Configuration logic
  exit 0
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
```

### Execution Model

| Directory | When | Idempotency |
|-----------|------|-------------|
| `configure/once/` | First run only | Flag file created on success |
| `configure/mac/` | Every run | Always executes |
| `configure/` | Every run | Always executes |

To re-run a "once" script, delete its flag:

```sh
rm ~/.dotfiles/flags/credentials
~/.dotfiles/configure.sh
```

## Managing Dotfiles

Dotfiles are managed with [GNU Stow](https://www.gnu.org/software/stow/). A wrapper script simplifies common operations:

```sh
# List all packages
dotfiles list

# List all managed files
dotfiles list --files

# Migrate existing files into a new package
dotfiles migrate zsh ~/.zshrc ~/.zshenv

# Apply all packages (re-stow)
dotfiles apply

# Add an empty package
dotfiles add vim

# Remove a package
dotfiles remove vim
```

### Package Structure

Each package mirrors the home directory structure:

```
stow/
└── git/
    ├── .gitconfig
    └── .gitignore
```

Running `dotfiles apply` creates symlinks:
- `~/.gitconfig` → `~/.dotfiles/stow/git/.gitconfig`
- `~/.gitignore` → `~/.dotfiles/stow/git/.gitignore`

## Blackhole DNS

Local ad/tracker blocking via `dnsmasq`. Domains in blacklists resolve to `0.0.0.0`.

```sh
# Fetch (or refresh) upstream blocklists
./blackhole/fetch.sh

# Generate hosts file
./blackhole/generate.sh > /usr/local/etc/dnsmasq.d/blackhole.conf

# Reload dnsmasq
sudo brew services restart dnsmasq
```

Customize blocking by altering whitelists and blacklists:
- `blackhole/blacklists/*.txt` — Domains to block
- `blackhole/whitelists/*.txt` — Domains to allow (overrides blacklists)

## GPG with 1Password

GPG passphrases are stored in 1Password and retrieved automatically via a custom `pinentry` program.

1. Store your GPG passphrase in 1Password
2. Set `OP_GPG_ITEM` in your shell profile (see `stow/sh/.profile`)
3. Configure `gpg-agent` to use the custom pinentry:

```
# ~/.gnupg/gpg-agent.conf
pinentry-program /Users/michael/.dotfiles/extra/pinentry.sh
```

## Dock/Undock

Scripts to toggle settings when connecting/disconnecting an external keyboard:

```sh
dock    # Natural scrolling OFF (scroll wheel matches content direction)
undock  # Natural scrolling ON (trackpad-style)
```

## Platform Support

| Platform | Status |
|----------|--------|
| macOS | ✅ Supported |
| Linux | 🚧 Planned |
| FreeBSD | 🚧 Planned |
| WSL | 🚧 Detected, not configured |
