export PATH=$PATH:$(go env GOPATH)/bin
export PATH="${PATH}:${HOME}/npm/bin"
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# Project Finder
fp() {
  cd $(find ~/Development/Projects -type d -maxdepth $FZF_DEPTH -mindepth $FZF_DEPTH | fzf)
}

## Refresh
alias refresh='exec zsh -l'
alias rf='exec zsh -l'
## Quit
alias q='exit'
alias quit='exit'
alias quite='exit'
## Git
alias lg='lazygit'
## Neovim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'
## Zsh
alias zshrc='nvim ~/.config/.zshrc'
alias zprofile='nvim ~/.config/.zprofile'
## Dotfiles
alias dot='cd ~/.config/ && nvim'
## Printenv
alias pe='printenv'
# Projects
alias proj='cd ~/Development/Projects'
alias pp='cd ~/Development/Projects/personal'
alias wd='cd ~/Development/Projects/weirddeer'

function kp() {
  kill -9 $(lsof -ti :$1)
}

eval "$(/opt/homebrew/bin/brew shellenv)"
