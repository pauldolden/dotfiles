export PATH=$PATH:$(go env GOPATH)/bin
export PATH="${PATH}:${HOME}/npm/bin"

source ~/.config/zsh/functions.zsh
source ~/.config/zsh/aliases.zsh

eval "$(/opt/homebrew/bin/brew shellenv)"
