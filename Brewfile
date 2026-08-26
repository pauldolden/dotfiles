tap "anomalyco/tap"
tap "hashicorp/tap"
tap "libkrun/krun", trusted: { formulae: ["gvproxy", "libkrun", "libkrunfw", "virglrenderer"] }
tap "nikitabobko/tap"
# Improved shell history for zsh, bash, fish and nushell
# No restart_service: the formula's service runs `atuin daemon start`, but the
# daemon is opt-in and atuin/config.toml does not set [daemon] enabled = true,
# so the client writes to sqlite directly and the service would idle.
brew "atuin"
# Secrets scanner built for configurability and speed. Runs as the global
# pre-commit hook (git/hooks/pre-commit).
brew "betterleaks"
# Resource monitor. C++ version and continuation of bashtop and bpytop
brew "btop"
# Terminal image previews for yazi
brew "chafa"
# Load/unload environment variables based on $PWD
brew "direnv"
# Docker CLI only — not Desktop. Exists alongside podman because DOCKER_HOST
# (zsh/exports.zsh) points it at podman's socket, so `docker` drives the podman
# machine. A real binary on PATH resolves for every caller; an alias would not,
# since scripts and MCP servers both run without a shell.
brew "docker"
# Compose v2 as a docker plugin. `docker compose` only finds it once
# ~/.docker/config.json names the plugin dir in cliPluginsExtraDirs, which the
# bootstrap merges in place — the same file gains registry auth on
# `docker login`, so it cannot be tracked here outright.
brew "docker-compose"
# Modern, maintained replacement for ls
brew "eza"
# Video thumbnails for yazi previews
brew "ffmpegthumbnailer"
# Declared explicitly rather than left to Xcode CLT. It arrived here as a
# transitive dependency of asdf, so removing asdf orphaned it and Homebrew's
# autoremove took it — leaving the older CLT git as the only one on PATH.
brew "git"
# Enable transparent encryption/decryption of files in a git repo
brew "git-crypt"
# Quickly rewrite git repository history
brew "git-filter-repo"
# Development framework for multimedia applications — yazi video previews
brew "gstreamer"
# Polyglot runtime manager (asdf rust clone). Owns every language runtime and
# most CLI tooling; see mise/config.toml.
brew "mise"
# Ambitious Vim-fork focused on extensibility and agility
brew "neovim"
# Package compiler and linker metadata toolkit
brew "pkgconf"
# Tool for managing OCI containers and pods
brew "podman"
# PDF rendering library — yazi document previews
brew "poppler"
# Static analysis. Project quality gates shell out to it.
brew "semgrep"
# Mesh VPN
brew "tailscale"
# Passphrase prompt for GPG. Not optional: ~/.gnupg/gpg-agent.conf names
# /opt/homebrew/bin/pinentry-mac explicitly, and this machine signs every
# commit with GPG — without it signing fails with no usable prompt.
brew "pinentry-mac"
# Terminal multiplexer
brew "tmux"
# Fish-like fast/unobtrusive autosuggestions for zsh
brew "zsh-autosuggestions"
# Fish shell like syntax highlighting for zsh
brew "zsh-syntax-highlighting"
# Better and friendly vi(vim) mode plugin for ZSH
brew "zsh-vi-mode"
# The AI coding agent built for the terminal.
brew "anomalyco/tap/opencode", trusted: true
# CLI tool to start Linux KVM or macOS HVF VMs using the libkrun
# Required by podman: brew's podman formula ships gvproxy and vfkit but not
# krunkit, and podman defaults to the libkrun provider on Apple Silicon, so
# `podman machine start` fails without it. Not in homebrew-core because the
# binary needs a Hypervisor.framework codesigning entitlement.
brew "libkrun/krun/krunkit", trusted: true
# Command-line interface for 1Password
cask "1password-cli"
# i3-like tiling window manager. Reads its config from ~/.config/aerospace, so
# unlike the shell config it needs no bootstrap symlink. trusted: is required —
# Homebrew 6 refuses casks from third-party taps without it, and `brew trust`
# records that in ~/.homebrew/trust.json, which is machine-local and untracked.
cask "nikitabobko/tap/aerospace", trusted: true
# Claude Code is NOT installed via brew on this machine. The native installer
# already owns /opt/homebrew/bin/claude and self-updates, so the cask errors
# with "there is already a Binary at ...". The work machine uses the cask;
# this is the one package where the two deliberately differ.
# Brings the power of Copilot coding agent directly to your terminal
cask "copilot-cli"
# The one browser whose chrome reads a stylesheet off disk, so it themes from
# theme/palette.toml like every other config here. Chrome and Safari expose no
# equivalent; see docs/BROWSER.md.
cask "firefox"
cask "font-zed-mono-nerd-font"
# Google Cloud CLI — gcloud, gsutil, bq. Cask is named gcloud-cli; the old
# google-cloud-sdk name is an alias, and having both installed is a duplicate.
cask "gcloud-cli"
# Terminal emulator that uses platform-native UI and GPU acceleration
cask "ghostty"
# Mouse behaviour macOS cannot express: it has one global scroll direction for
# every pointing device, and no way to bind the thumb buttons. See
# docs/MACOS_INPUT.md.
cask "hammerspoon"
# Markdown notes. The notes root itself lives outside this repo; the aliases
# that reach it are machine-local (zsh/aliases.local.zsh).
cask "obsidian"
# Podman GUI. The CLI and the machine come from the podman formula above; this
# is only the inspector, so it is safe to skip on a headless rebuild.
cask "podman-desktop"
# Native GUI tool for relational databases
cask "tableplus"
# npm packages are NOT declared here. brew bundle runs without mise activated,
# so npm is not on its PATH and every npm directive reports as missing forever —
# a permanent false warning in the bootstrap. node belongs to mise, so its global
# packages are declared in mise/config.toml via the npm: backend instead.
