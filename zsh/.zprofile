# Go path (if go is installed)
command -v go &>/dev/null && export PATH="$PATH:$(go env GOPATH)/bin"

export PATH="${PATH}:${HOME}/npm/bin"

source ~/.config/zsh/functions.zsh
source ~/.config/zsh/aliases.zsh

# Homebrew (macOS only)
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
