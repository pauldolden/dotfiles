# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zprofile.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.pre.zsh"

export PATH=$PATH:$(go env GOPATH)/bin
export PATH="${PATH}:${HOME}/npm/bin"
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# Project Finder
fp() {
  cd $(find ~/Development/Projects -type d -maxdepth $FZF_DEPTH -mindepth $FZF_DEPTH | fzf)
}

# Aliases
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
## Sls
alias dd='sls deploy --stage dev'
alias rd='sls remove --stage dev'
## Printenv
alias pe='printenv'
alias actm1='act --container-architecture linux/amd64'
# Projects
alias proj='cd ~/Development/Projects'
alias pp='cd ~/Development/Projects/personal'
alias wd='cd ~/Development/Projects/weirddeer'

DISABLE_AUTO_TITLE="true"
precmd () { print -Pn "\e]0;${PWD##*/}\a" }

eval "$(/opt/homebrew/bin/brew shellenv)"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zprofile.post.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.post.zsh"
