# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
export PATH="${PATH}:${HOME}/npm/bin"
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH

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
alias gs="git status"
## Neovim
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias nv="nvim"
## Zsh
alias zshrc="nvim ~/.zshrc"
alias zprofile="nvim ~/.zprofile"
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

eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/tokyonight_storm.omp.json)"
eval "$(zoxide init zsh)"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
