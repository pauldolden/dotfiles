export PATH=$PATH:$(go env GOPATH)/bin
export PATH="${PATH}:${HOME}/npm/bin"
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

source ~/.config/zsh/functions.zsh
source ~/.config/zsh/aliases.zsh

eval "$(/opt/homebrew/bin/brew shellenv)"
