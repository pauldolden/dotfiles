# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zprofile.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.pre.zsh"

export PATH="${PATH}:${HOME}/npm/bin"
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Aliases
## Refresh
alias refresh="exec zsh -l"
alias rf="exec zsh -l"
## Quit
alias q="exit"
alias quit="exit"
alias quite="exit"
## Fzf
alias fp='cd $(find ~/Projects -type d -maxdepth 1 | fzf)'
## Git
alias lg="lazygit"
## Neovim
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias nv="nvim"
## Zsh
alias zshrc="nvim ~/.config/.zshrc"
alias zprofile="nvim ~/.config/.zprofile"
## Dotfiles
alias dot="cd ~/.config/ && nvim"
## Sls
alias dd="sls deploy --stage dev"
alias rd="sls remove --stage dev"
## Printenv
alias pe="printenv"
alias actm1="act --container-architecture linux/amd64"

DISABLE_AUTO_TITLE="true"

precmd () { print -Pn "\e]0;${PWD##*/}\a" }

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(zoxide init zsh)"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zprofile.post.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.post.zsh"
